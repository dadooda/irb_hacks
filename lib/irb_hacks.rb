require "yaml"

Dir[File.join(File.dirname(__FILE__), "irb_hacks/**/*.rb")].each {|fn| require fn}

module IrbHacks
  def self.ValueNow(value)
    raise ValueNowException, [value]
  end

  def self.less_cmd
    @less_cmd
  end

  def self.less_cmd=(cmd)
    @less_cmd = cmd
  end

  class ValueNowException < StandardError; end

  #--------------------------------------- Defaults

  self.less_cmd = "less -R"
end
