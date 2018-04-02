class MTENV
  class Active < Admiral::Command
    define_help description: "Show the currently-active Myst version."

    def run
      active_version = `cat #{File.expand_path("~/.mtenv/global")}`
      if active_version.empty?
        puts "No Myst version is currently active."
      else
        puts active_version
      end
    end
  end

  register_sub_command active : Active
end
