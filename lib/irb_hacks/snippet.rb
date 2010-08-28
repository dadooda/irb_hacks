require "readline"

module IrbHacks   #:nodoc:
  module Snippet
    HISTORY_FILE = File.join(ENV["HOME"], ".irb_snippet_history")
    HISTORY_SIZE = 20

    # Edit code snippet.
    def self.edit
      ##p "R::H before", Readline::HISTORY.to_a
      ##p "@history at inv", @history

      # Push stuff into RL history.
      npushed = @history.size
      @history.each {|s| Readline::HISTORY.push s}

      ##p "R::H after push", Readline::HISTORY.to_a

      # NOTE: Readline help is missing. Copied from somewhere else.
      input = Readline.readline("(snippet)>> ", true)

      if not input.empty?
        # Accept entry.
        @history << input

        # ["wan", "tew", "free", "tew"] should render into ["wan", "free", "tew"] with "tew" being the last input shippet.
        @history = (@history.reverse.uniq).reverse
      end

      # Pop stuff out of RL history.
      (npushed + 1).times {Readline::HISTORY.pop}

      ##p "R::H after", Readline::HISTORY.to_a

      # Save history -- we can't know when the session is going to end.
      save_history

      # Don't clutter IRB screen with anything extra.
      nil
    end

    def self.history
      @history
    end

    def self.history=(ar)
      @history = ar
    end

    def self.load_history
      @history = begin
        content = File.read(HISTORY_FILE)
        YAML.load(content)
      rescue
        nil
      end

      @history = [%{puts "YOUR test code here"}] if not @history.is_a? Array
    end

    # Run code snippet.
    # If <tt>IrbHacks#ValueNow</tt> is invoked anywhere, return its argument.
    #
    #   IrbHacks.ValueNow(myobj)
    def self.run(*args, &block)
      if (code = @history.last)
        begin
          eval(code, &block)
        rescue IrbHacks::ValueNowException => e
          # If invoked as documented, `e.message` is always an array.
          e.message[0]
        end
      end
    end

    def self.save_history
      # Truncate a saved version of @history.
      hist = @history.size > HISTORY_SIZE ? @history.slice(-HISTORY_SIZE..-1) : @history
      File.open(HISTORY_FILE, "w") do |f|
        f.write YAML.dump(hist)
      end
    end

    #--------------------------------------- Init

    load_history
  end # Snippet
end # IrbHacks
