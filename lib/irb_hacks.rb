Dir[File.join(File.dirname(__FILE__), "irb_hacks/**/*.rb")].each {|fn| require fn}

# Yet another set of IRB hacks.
#
# Summary of features brought to IRB:
#
# * <tt>a</tt> and <tt>ae</tt> methods to invoke or edit code snippets.
# * <tt>less</tt> method to interactively dump data with OS pager program (e.g. <tt>less</tt>).
# * IrbHacks::break to instantly return value from code into IRB.
module IrbHacks   #:doc:
  # Break execution, instantly return a value if caller is invoked from a snippet.
  #
  #   def myfunc
  #     puts "Reading name..."
  #     name = File.read(...)
  #     IrbHacks.break name     # Pass what's been read back to console.
  #
  #     ...
  #   end
  #
  #   irb> ae
  #   snippet>> myfunc
  #   irb> a
  #   Reading name...
  #   => "John Smith"
  def self.break(value = nil)
    raise BreakException, [value]
  end

  # Access configuration object. See IrbHacks::Config.
  #
  #   IrbHacks.conf
  #   IrbHacks.conf.snippet_history_size = 200
  def self.conf
    @conf ||= Config.new
  end
end
