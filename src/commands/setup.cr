require "file_utils"
require "ecr"

# The shim is written in `src/scripts/shim.ecr.sh`. This macro loads the content
# of that file into a string at compile time, avoiding the need to use a
# heredoc or bundle resource files when distributing this tool. ECR takes care
# of embedding in Default::MTENV_HOME into the script
MYST_SHIM = ECR.render "#{__DIR__}/../scripts/shim.ecr.sh"

class MTENV
  class Setup < Admiral::Command
    define_help description: "Ensure that `mtenv` is properly and fully installed."

    define_flag shims_dir, long: "shims-dir", \
                description: "Use specified directory to store shims."

    def run
      shims_location = ask_for_shims_location!
      # Ensure the $MTENV_HOME dir exists and has all of the
      # necessary components (versions, global, shims, etc.).
      FileUtils.cd(MTENV.home) do
        init_mtenv_home shims_location
        link_shims      shims_location
      end

      puts
      puts "mtenv setup finished successfully."
    end

    private def init_mtenv_home(shims_location)
      puts "Initializing mtenv home: `#{MTENV.home}`..."
      FileUtils.mkdir_p "versions"
      FileUtils.mkdir_p "shims"
      FileUtils.touch   "global"
      # Store the shims bindir location for use in the future (e.g., `implode`).
      File.write filename: "shims_dir", content: shims_location

      puts "Creating shims..."
      File.open("shims/myst", mode: "w", perm: 0o755) do |f|
        f.truncate
        f.puts(MYST_SHIM)
      end
    end

    private def link_shims(shims_location)
      puts "Linking shims to #{shims_location}"

      myst_shim_path    = MTENV.from_home "shims/myst"
      myst_install_path = File.join(shims_location, "myst")

      case
      when File.symlink?(myst_install_path)
        existing_path = File.real_path(myst_install_path)
        if existing_path != myst_shim_path
          abort <<-MSG
            `myst` already exists in #{shims_location} and points to #{existing_path}
            Remove it and re-run this setup to allow `mtenv` to install a new shim.
          MSG
        end
      when File.exists?(myst_install_path)
        abort <<-MSG
          `myst` already exists in #{shims_location} as a plain file.
          Remove it and re-run this setup to allow `mtenv` to install a new shim.
        MSG
      else
        File.symlink(myst_shim_path, myst_install_path)
      end
    end

    private def ask_for_shims_location!
      # First check if mtenv was passed a --shims-dir flag
      if (path = flags.shims_dir)
        path = File.expand_path path
        (Dir.exists? path)    || Util.fail! "Passed shims-dir does not exist!"
     ###(File.writable? path) || Util.fail! "mtenv lacks write access to shims-dir" # TODO: Find out whether or not to include this check
        return path
      end

      # If not, prompt for location
      location = Readline.readline prompt: "Where should mtenv link shims to? (default '#{Default::BINDIR}'):"
      if location.nil? || location.empty?
        puts "Using default location..."
        location = Default::BINDIR
      end

      location = File.expand_path(location)
      # TODO: See previous TODO, the check should be the same both places
      if Dir.exists?(location)
        return location
      else
        abort "Requested shims location `#{location}` does not exist. Aborting setup."
      end
    end
  end

  register_sub_command setup : Setup
end
