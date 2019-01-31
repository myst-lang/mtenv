class MTENV
  class Versions < Admiral::Command
    define_help description: "List all currently-installed Myst versions."

    def run
      puts `ls #{MTENV.from_home("versions")}`
    end
  end

  register_sub_command versions : Versions
end
