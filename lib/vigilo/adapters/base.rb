module Vigilo
  class Adapter
    def initialize(listener)
      @listener = listener.new
    end

    def watch(directories, &block)
      @listener.callback(&block)
      @listener.directories directories
      @listener.start
    end
  end

  module Adapters
    module Listener
      def callback(&block)
        @block = block
      end

      def directories(directories)
        @files = Hash.new {|h,k| h[k] = {} }
        @directories = directories

        directories.each do |directory|
          Dir.glob("#{directory}/**/*").each do |file|
            insert(directory, file)
          end
        end
      end

      CHANGES = {:changed => [], :added => [], :removed => []}

      def on_change(directories)
        changes = {:changed => [], :added => [], :removed => []}

        directories.each do |dir|
          base_dir = dir.sub(/\/$/, '')
          diff(base_dir, changes)

          Dir["#{base_dir}/*"].each do |file|
            next if file =~ /\/\./
            next unless File.file?(file)
            next if @files[base_dir][File.basename(file)]

            changes[:added].push file
            insert(base_dir, file)
          end
        end

        @block.call(changes) unless changes == CHANGES
      end

      def diff(base, changed_files)
        @files[base].each do |file, stat|
          fullname = File.join(base, file)

          if File.exist?(fullname)
            new_stat = File.stat(fullname)
            if stat.mtime != new_stat.mtime
              changed_files[:changed] << fullname
              @files[base][file] = new_stat
            end
          else
            @files[base].delete(file)
            changed_files[:removed] << fullname
          end
        end

        changed_files
      end

      def insert(directory, file)
        if File.file?(file)
          @files[File.dirname(file)][File.basename(file)] = File.stat(file)
        end
      end
    end
  end
end


