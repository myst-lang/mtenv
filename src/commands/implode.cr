class MTENV
  class Implode < Admiral::Command
    define_help description: "Completely uninstall mtenv and all Myst versions."

    def run
      require_confirmation!

      unless Dir.exists?(File.expand_path(MTENV.home))
        abort "#{MTENV.home} does not exist. Cannot ensure implosion."
      end

      shims_path = File.read(File.expand_path("~/.mtenv/shims_dir"))
      puts ". Removing links to shims from #{shims_path}"
      FileUtils.rm(File.join(shims_path, "myst"))

      puts ". Removing `#{MTENV.home}`"
      FileUtils.rm_r(File.expand_path(MTENV.home))

      puts "Successfully imploded mtenv."
    end


    private def require_confirmation!
      puts "Are you sure you want to completely uninstall mtenv? This cannot be undone."
      puts "The `mtenv` command will remain installed, but all installations will be lost."
      puts "Type 'implode' to confirm your intent."
      print "> "
      unless (confirmation = gets) && confirmation == "implode"
        abort("Not uninstalling. Confirmation did not match 'implode'.")
      end
    end
  end

  register_sub_command implode : Implode
end
