module IrbHacks   #:nodoc:
  module CoreExtensions   #:nodoc:
    module Kernel   #:nodoc:
      module SingletonMethods
        # See <tt>InstanceMethods</tt> for documentation.
        def a(*args, &block)
          IrbHacks::Snippet.run(*args, &block)
        end

        # See <tt>InstanceMethods</tt> for documentation.
        def ae(*args)
          IrbHacks::Snippet.edit(*args)
        end
      end # SingletonMethods

      module InstanceMethods
        private

        # Run code snippet.
        # See <tt>IrbHacks::Snippet.run</tt>.
        def a(*args, &block)
          ::Kernel.a(*args, &block)
        end

        # Edit code snippet.
        # See <tt>IrbHacks::Snippet.edit</tt>.
        def ae(*args)
          ::Kernel.ae(*args)
        end
      end
    end
  end
end

Kernel.extend IrbHacks::CoreExtensions::Kernel::SingletonMethods

module Kernel   #:nodoc:
  include IrbHacks::CoreExtensions::Kernel::InstanceMethods
end

# Reinclude module into those using it.
ObjectSpace.each_object(Module) {|m| (m.class_eval {include Kernel} if m.include? Kernel) rescue nil}
