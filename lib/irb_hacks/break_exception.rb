module IrbHacks
  # Exception class used by IrbHacks::break.
  class BreakException < Exception
    attr_accessor :value

    def initialize(attrs = {})
      attrs.each {|k, v| send("#{k}=", v)}
    end
  end
end
