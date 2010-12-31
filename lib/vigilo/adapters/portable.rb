require "vigilo/adapters/base"

module Vigilo
  module Adapters
    class Portable
      include Listener

      def start
        loop do
          directories = []
          @directories.each do |directory|
            Dir.glob("#{directory}/**/*").each do |file|
              directories << file if File.directory?(file)
            end
          end
          directories.concat(@directories)
          on_change(directories)
          sleep 1
        end
      end
    end
  end
end

