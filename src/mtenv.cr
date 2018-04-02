require "admiral"

require "./util.cr"

class MTENV < Admiral::Command
  define_help description: "The Myst language environment manager."

  def run
    puts help
  end
end

require "./commands/*"

MTENV.run
