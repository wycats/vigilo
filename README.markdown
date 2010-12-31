# What is Vigilo?

Vigilo is a dead-simple file system watcher for Ruby.

# API

    Vigilo::Watcher.watch(dir1, dir2) do |changed, added, deleted|
      # created is an Array of files changed, or nil if none changed
      # added is an Array of files added, or nil if none added
      # deleted is an Array of files deleted, or nil if none deleted
    end

You can also start a watch inside a thread to keep it going in the
background.

# Resource usage

On my Mac, the portable (polling) backend used 2.5% CPU while the
FSEvents backend used 0.4% CPU.

# In progress

Vigilo is brand new and currently only has support for FSEvents and File
System polling. Support for inotify is coming.

At the moment, I have only tested it on my local machine and the final
API isn't in place, so feel free to look, but don't rely on anything
just yet.

Tests are in progress.

