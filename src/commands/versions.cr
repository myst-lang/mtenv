class MTENV
  class Versions < Admiral::Command
    define_help description: "List all currently-installed Myst versions."

    def run
      Process.exec("ls", [File.expand_path("~/.mtenv/versions")])
    end
  end

  register_sub_command versions : Versions
end