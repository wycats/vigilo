module Vigilo
  class Watcher
    def self.watch(*directories, &block)
      listener = ENV["VIGILO_ADAPTER"] ? Vigilo::Adapters.const_get(ENV["VIGILO_ADAPTER"]) : Vigilo::Adapters::Portable
      watcher = new(Vigilo::Adapter.new(listener), *directories)
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
