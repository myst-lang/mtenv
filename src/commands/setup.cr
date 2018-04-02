require "file_utils"

# The shim is written in `src/scripts/shim.sh`. This macro loads the content
# of that file into a string at compile time, avoiding the need to use a
# heredoc or bundle resource files when distributing this tool.
MYST_SHIM = {{ "#{`cat #{__DIR__}/../scripts/shim.sh`}" }}

class MTENV
  class Setup < Admiral::Command
    define_help description: "Ensure that `mtenv` is properly and fully installed."

    def run
      shims_location = ask_for_shims_location!
      # Ensure the `.mtenv` dir exists in the home directory and has all of the
      # necessary components (versions, global, shims, etc.).
      FileUtils.cd(ENV["HOME"]) do
        puts "Initializing `~/.mtenv/`"
        FileUtils.mkdir_p(".mtenv/versions")
        FileUtils.touch(".mtenv/global")
        FileUtils.mkdir_p(".mtenv/shims")
        # Store the shims location for use in the future (e.g., `implode`).
        File.write(".mtenv/shims_dir", shims_location)

        puts "Creating shims"
        File.open(".mtenv/shims/myst", mode: "w", perm: 0o755) do |f|
          f.truncate
          f.puts(MYST_SHIM)
        end

        # Create mtenv-controlled shims for the Myst binary.
        puts "Linking shims to #{shims_location}"
        myst_shim_path = File.expand_path("~/.mtenv/shims/myst")
        myst_install_path = File.join(shims_location, "myst")
        case
        when File.symlink?(myst_install_path)
          existing_path = File.real_path(myst_install_path)
          if existing_path != myst_shim_path
            STDERR.puts "`myst` already exists in #{shims_location} and points to #{existing_path}"
            STDERR.puts "Remove it and re-run this setup to allow `mtenv` to install a new shim."
            exit(1)
          end
        when File.exists?(myst_install_path)
          STDERR.puts "`myst` already exists in #{shims_location} as a plain file."
          STDERR.puts "Remove it and re-run this setup to allow `mtenv` to install a new shim."
          exit(1)
        else
          File.symlink(myst_shim_path, myst_install_path)
        end
      end

      puts "\nmtenv setup finished successfully."
    end


    private def ask_for_shims_location!
      print "Where should mtenv create links to shims? (default '/usr/local/bin'): "
      location = gets
      if location.nil? || location.empty?
        location = "/usr/local/bin"
      end

      location = File.expand_path(location)

      if location && Dir.exists?(location)
        return location
      else
        abort "Requested shims location `#{location}` does not exist. Aborting setup."
      end

    end
  end

  register_sub_command setup : Setup
end
