module IrbHacks   #:nodoc:
  module CoreExtensions   #:nodoc:
    module Kernel   #:nodoc:
      module SingletonMethods
        # See <tt>InstanceMethods</tt> for documentation.
        def less(*args, &block)
          less_cmd = IrbHacks.less_cmd

          if not block
            # Non-block invocation.
            if args.size < 1
              # We're interactive anyway. Why not give user a quick prompt?
              STDERR.puts "Nothing to show. Invoke as less(args) or less(options, &block)"
            else
              File.popen(less_cmd, "w") do |f|
                f.puts args
              end
            end
          else
            # Block invocation.

            # Handle options.
            options = {}

            args.each do |arg|
              if arg.is_a? Hash
                ##p "arg hash", arg
                options.merge! arg
              elsif [Symbol, String].include? arg.class
                ##p "arg sym/str", arg
                options.merge! arg.to_sym => true
              else
                raise ArgumentError, "Unsupported argument #{arg.inspect}"
              end
            end

            o_stderr = (v = options.delete(:stderr)).nil?? false : v

            raise ArgumentError, "Unknown option(s): #{options.inspect}" if not options.empty?

            old_stdout = STDOUT.clone
            old_stderr = STDERR.clone if o_stderr

            File.popen(less_cmd, "w") do |f|
              STDOUT.reopen(f)
              STDERR.reopen(f) if o_stderr
              yield
              STDOUT.reopen(old_stdout)
              STDERR.reopen(old_stderr) if o_stderr
            end
          end # if block

          nil
        end # less
      end # SingletonMethods

      module InstanceMethods
        private

        # Dump program data with GNU <tt>less</tt>.
        #
        # Plain form:
        #   less "hello", "world"
        #   less mydata
        #
        # Block form:
        #   less do
        #     puts "hello, world"
        #   end
        #
        #   less(:stderr => true) do
        #     puts "to stdout"
        #     STDERR.puts "to stderr"
        #   end
        #
        # Block form options:
        #   :stderr => T|F      # Redirect STDERR too.
        #
        # If block form option is <tt>String</tt> or <tt>Symbol</tt>, it's automatically
        # converted to a hash like <tt>{:var => true}</tt>. Thus, <tt>less(:stderr => true)</tt>
        # and <tt>less(:stderr)</tt> are identical.
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
