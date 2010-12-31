require "fsevent"

module Vigilo
  module Adapters
    class FSEvents
      class Listener < FSEvent
        def callback(&block)
          @block = block
        end

        def directories(directories)
          @files = Hash.new {|h,k| h[k] = {} }

          directories.each do |directory|
            Dir.glob("#{directory}/**/*", File::FNM_DOTMATCH).each do |file|
              insert(directory, file)
            end
          end
        end

        def on_change(directories)
          changes = {:changed => [], :added => [], :removed => []}

          directories.each do |dir|
            base_dir = dir.sub(/\/$/, '')
            diff(base_dir, changes)

            Dir["#{base_dir}/*"].each do |file|
              next unless File.file?(file)
              next if @files[base_dir][File.basename(file)]

              changes[:added].push file
              insert(base_dir, file)
            end
          end

          @block.call(changes)
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

      def initialize
        @listener = Listener.new
      end

      def watch(directories, &block)
        @listener.directories directories
        @listener.callback(&block)
        @listener.watch_directories(directories)
        puts "READY"
        @listener.start
      end

    private
      def insert(directory, file)
        if File.file?(file)
          @files[File.dirname(file)][File.basename(file)] = File.stat(file)
        end
      end
    end
  end
end
