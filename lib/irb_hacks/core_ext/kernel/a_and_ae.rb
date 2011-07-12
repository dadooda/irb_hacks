module IrbHacks
  module CoreExtensions   #:nodoc:
    module Kernel   #:nodoc:
      module SingletonMethods   #:nodoc:
        def a(*args, &block)
          Snippet.run(*args, &block)
        end

        def ae(*args)
          Snippet.edit(*args)
        end
      end # SingletonMethods

      module InstanceMethods
        private

        # Run code snippet. See IrbHacks::Snippet::run.
        def a(*args, &block)
          ::Kernel.a(*args, &block)
        end

        # Interactively edit code snippet. See IrbHacks::Snippet::edit.
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
