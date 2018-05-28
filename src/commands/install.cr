require "tempfile"

class MTENV
  class Install < Admiral::Command
    define_help description: "Install a new version of Myst."

    define_argument version : String,
                    description: "A SemVer version number of commit SHA to install",
                    required: true

    define_argument name : String,
                    description: "An alias name to use for the new installation."

    GITHUB_URL = "api.github.com/repos/myst-lang/myst/tarball"

    def run
      Util.require_setup!
      validate_version!

      tarball = Tempfile.new("myst-#{version_name}", ".tar.gz")
      if download_version_tarball(arguments.version, to: tarball.path)
        install_location = MTENV.from_home("versions/#{version_name}")
        FileUtils.mkdir_p(install_location)
        unpack_tarball(tarball.path, to: install_location)
        build_executable(install_location)
      else
        STDERR.puts "Could not find a Myst version matching '#{arguments.version}'."
        exit(1)
      end

      tarball.unlink
    end

    def version_name
      arguments.name || arguments.version
    end


    private def validate_version!
      unless Util.versionish?(arguments.version)
        STDERR.puts "'#{arguments.version}' is not a valid version identifier."
        STDERR.puts "Versions must be given as either SemVer numbers (vX.X.X) or commit SHAs"
        exit(1)
      end
    end

    private def download_version_tarball(version, to file)
      # curl GitHub for a tarball of the myst repository at the requested version.
      # -sL     - run silently, and follow GitHub's redirects automatically
      # > file  - output the content into `file`.
      `curl -sL #{GITHUB_URL}/#{version} > #{file}`
    end

    private def unpack_tarball(tar_path, to destination)
      # Unpack the given tar ball into the given destination.
      # -xf                   - unpack from a file
      # -C                    - sets the destination for the unpack
      # --strip-components=1  - remove the containing directory name from GitHub.
      `tar -xf #{tar_path} -C #{destination} --strip-components=1`
    end

    private def build_executable(install_location)
      FileUtils.cd(install_location) do
        `shards build`
      end
    end
  end

  register_sub_command install : Install
end
