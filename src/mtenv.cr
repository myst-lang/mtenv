require "admiral"
require "readline"

# Always expand MTENV_HOME at launch
# this saves a lot of problems
if home = ENV["MTENV_HOME"]?
  ENV["MTENV_HOME"] = File.expand_path home
end

require "./util.cr"

class MTENV < Admiral::Command
  define_help description: "The Myst language environment manager."

  def run
    puts help
  end

  def self.home
    if home = ENV["MTENV_HOME"]?
      (Dir.exists? home)    || Util.fail! %<Environments MTENV_HOME: "#{home}" does not exists!>
      (File.writable? home) || Util.fail! %<Environments MTENV_HOME: "#{home}" is not writable!>
      return home
    else
      return Default::HOME
    end
  end

  def self.from_home(path : String)
    File.expand_path "#{self.home}/#{path}"
  end

  module Default
    HOME   = "~/.mtenv"
    BINDIR = "/usr/local/bin"
  end
end

require "./commands/*"

MTENV.run
