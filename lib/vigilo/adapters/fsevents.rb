require "fsevent"
require "vigilo/adapters/base"

module Vigilo
  module Adapters
    class FSEvents < ::FSEvent
      include Listener

      def directories(directories)
        super
        watch_directories(directories)
      end
    end
  end
end
