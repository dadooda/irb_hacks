require "yaml"

Dir[File.join(File.dirname(__FILE__), "irb_hacks/**/*.rb")].each {|fn| require fn}

module IrbHacks
  # Break execution, return value if invoked from `a`.
  #
  #   IrbHacks.break
  #   IrbHacks.break("hi")
  def self.break(value = nil)
    raise BreakException, [value]
  end

  def self.less_cmd
    @less_cmd
  end

  def self.less_cmd=(cmd)
    @less_cmd = cmd
  end

  class BreakException < Exception; end

  #--------------------------------------- Defaults

  self.less_cmd = "less -R"
end
