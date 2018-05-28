class MTENV
  class Use < Admiral::Command
    define_help description: "Set the version of Myst to use."

    define_argument version : String,
                    description: "The name of the version to uninstall",
                    required: true

    def run
      version_path = MTENV.from_home("versions/#{arguments.version}")

      unless Dir.exists?(version_path)
        abort "Version #{arguments.version} is not currently installed."
      end

      File.open(MTENV.from_home("global"), "w") do |f|
        f.truncate
        f.print(arguments.version)
      end

      puts "Active Myst version is now #{arguments.version}"
    end
  end

  register_sub_command use : Use
end
