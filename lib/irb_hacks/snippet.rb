require "readline"

module IrbHacks
  # Snippet manipulation internals.
  module Snippet
    # Initializer.
    def self._initialize    #:nodoc:
      load_history
    end

    # On-the-fly initializer.
    def self._otf_init    #:nodoc:
      # Consider job done, replace self with a blank.
      class_eval {
        def self._otf_init    #:nodoc:
        end
      }

      _initialize
    end

    # Interactively edit code snippet.
    def self.edit
      _otf_init

      # Gracefully catch Ctrl-C.
      old_sigint = trap("INT") do
        puts "\nAborted"
        return nil
      end

      #DEBUG
      ##p "RH at inv", Readline::HISTORY.to_a
      ##p "@history at inv", @history

      rl_history = _replace_rl_history(@history)

      ##p "RH at cp 1", Readline::HISTORY.to_a    #DEBUG

      # Read input.
      # NOTE: Readline help is missing.
      input = Readline.readline(IrbHacks.conf.snippet_prompt, true).strip

      return nil if input.empty?

      # Accept input.
      @history << input

      # Remove duplicates. Most recent bubble up.
      # [1, 2, 3, 2] will render into [1, 3, 2] with 2 being the last snippet.
      @history = (@history.reverse.uniq).reverse

      ##p "RH after restore", Readline::HISTORY.to_a    #DEBUG

      # Save our history now.
      save_history

      # Don't clutter IRB screen with anything extra.
      nil
    ensure
      ##puts "-- ensure"    #DEBUG
      trap("INT", &old_sigint) if old_sigint
      _replace_rl_history(rl_history) if rl_history
    end

    def self.history
      @history
    end

    def self.history=(ar)
      @history = ar
    end

    # Load history from a file.
    def self.load_history
      @history = begin
        File.readlines(File.expand_path(IrbHacks.conf.snippet_history_file)).map(&:chomp)
      rescue
        [%{puts "YOUR test code here"}]
      end
    end

    # Run latest edited code snippet. If IrbHacks::break is called anywhere, immediately return its argument.
    def self.run(*args, &block)
      _otf_init

      if (code = @history.last)
        begin
          # NOTE: Passing `binding` is important to provide a better backtrace when exception occurs.
          eval(code, binding, &block)
        rescue IrbHacks::BreakException => e
          return e.value
        end
      end
    end

    # Save history to a file.
    def self.save_history
      # Truncate and save history.
      # NOTE: It's more logical (WYSIWYG) to truncate @history live, not its copy. Thus the user will see what's going to be saved & restored.
      @history.slice!(0..-(IrbHacks.conf.snippet_history_size + 1))
      File.open(File.expand_path(IrbHacks.conf.snippet_history_file), "w") do |f|
        f.puts @history
      end
    end

    #---------------------------------------

    # Clear Readline history and optionally replace it with new content.
    # Return previous content.
    def self._replace_rl_history(ar = nil)    #:nodoc:
      out = []
      while (s = Readline::HISTORY.shift); out << s; end
      ar.each {|s| Readline::HISTORY << s} if ar
      out
    end
  end # Snippet
end # IrbHacks
