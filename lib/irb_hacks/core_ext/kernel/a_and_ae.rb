module IrbHacks   #:nodoc:
  module CoreExtensions   #:nodoc:
    module Kernel   #:nodoc:
      module SingletonMethods
        # Run code snippet.
        # See <tt>IrbHacks::Snippet.run</tt>.
        def a(*args, &block)
          IrbHacks::Snippet.run(*args, &block)
        end

        # Edit code snippet.
        # See <tt>IrbHacks::Snippet.edit</tt>.
        def ae(*args)
          IrbHacks::Snippet.edit(*args)
        end
      end

      ::Kernel.extend SingletonMethods
    end
  end
end

module Kernel   #:nodoc:
  private

  def a(*args, &block)
    ::Kernel.a(*args, &block)
  end

  def ae(*args)
    ::Kernel.ae(*args)
  end
end
