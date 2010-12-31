module Vigilo
  class Watcher
    def self.watch(*directories, &block)
      watcher = new(Vigilo::Adapters::FSEvents.new, *directories)
      watcher.start(&block)
    end

    def initialize(adapter, *directories)
      @adapter = adapter
      @directories = directories
    end

    def start(&block)
      @adapter.watch(@directories, &block)
    end
  end
end
