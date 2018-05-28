require "admiral"

require "./util.cr"

class MTENV < Admiral::Command
  define_help description: "The Myst language environment manager."

  def run
    puts help
  end

  def self.home
    if home = ENV["MTENV_HOME"]?
        Dir.exists?(home) && File.writable?(home) && return home
    end

    "~/.mtenv"
  end

  def self.from_home(path : String)
    File.expand_path "#{self.home}/#{path}"
  end
end

require "./commands/*"

MTENV.run
