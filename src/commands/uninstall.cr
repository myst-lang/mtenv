require "file_utils"

class MTENV
  class Uninstall < Admiral::Command
    define_help description: "Uninstall specified myst version"

    define_argument version : String,
                    description: "The name of the version to uninstall",
                    required: true

    def run
      version_path = MTENV.from_home("versions/#{arguments.version}")
      if Dir.exists?(version_path)
        puts "Uninstalling '#{arguments.version}'"
        FileUtils.rm_r(version_path)
        puts "Successfully uninstalled #{arguments.version}"
      else
        puts "Version '#{version_path}' is not an installed Myst version."
      end
    end
  end

  register_sub_command uninstall : Uninstall
end
