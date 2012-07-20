module IrbHacks
  module CoreExtensions   #:nodoc:
    module Kernel   #:nodoc:
      module SingletonMethods   #:nodoc:
        # @see {InstanceMethods#less}
        def less(*args, &block)
          # Handle content & options.
          content = []
          o = {}
          options = {}

          begin
            if block
              args.each do |arg|
                if arg.is_a? Hash
                  options.merge! arg
                elsif [String, Symbol].any? {|klass| arg.is_a? klass}
                  options.merge!(arg.to_sym => true)
                else
                  raise ArgumentError, "Unsupported argument: #{arg.inspect}"
                end
              end

              o[k = :line] = options.delete(k)
              o[k = :stderr] = options.delete(k)
            else
              # Non-block.
              args.each do |arg|
                if arg.is_a? Hash
                  options.merge! arg
                else
                  content << arg
                end
              end

              o[k = :line] = options.delete(k)
            end # if block

            if content.empty?
              raise ArgumentError, "No content to browse"
            end

            if not options.empty?
              raise ArgumentError, "Unknown option(s): #{options.inspect}"
            end
          rescue ArgumentError => e
            # NOTE: We are interactive, print it friendly.
            return STDERR.puts e.message
          end # begin/rescue

          ##DT.p "content", content
          ##DT.p "options", options
          ##DT.p "o", o

          cmd = [
            IrbHacks.conf.less_cmd,
            ("+#{o[:line]}" if o[:line]),
          ].compact.join(" ")

          # Run the pager.
          if block
            old_stdout = STDOUT.clone
            old_stderr = STDERR.clone if o[:stderr]

            File.popen(cmd, "w") do |f|
              STDOUT.reopen(f)
              STDERR.reopen(f) if o[:stderr]
              yield
              STDOUT.reopen(old_stdout)
              STDERR.reopen(old_stderr) if o[:stderr]
            end
          else
            # Non-block.
            File.popen(cmd, "w") do |f|
              f.puts content
            end
          end

          nil
        end # less
      end # SingletonMethods

      module InstanceMethods
        private

        # Browse program data with GNU <tt>less</tt> or other configured OS pager.
        #
        # Plain form:
        #
        #   less "hello"
        #   less "hello", "world"
        #   less data, :line => 10
        #
        # Block form:
        #
        #   less do
        #     puts "hello, world"
        #   end
        #
        #   less(:stderr => true) do
        #     puts "to stdout"
        #     STDERR.puts "to stderr"
        #   end
        #
        #   less(:stderr) {...}     # Shortcut form of saying `:stderr => true`.
        #
        # @see {IrbHacks::Config::less_cmd}
        def less(*args, &block)
          ::Kernel.less(*args, &block)
        end
      end # InstanceMethods
    end # Kernel
  end # CoreExtensions
end

Kernel.extend IrbHacks::CoreExtensions::Kernel::SingletonMethods

module Kernel   #:nodoc:
  include IrbHacks::CoreExtensions::Kernel::InstanceMethods
end

# Reinclude module into those using it.
ObjectSpace.each_object(Module) {|m| (m.class_eval {include Kernel} if m.include? Kernel) rescue nil}
