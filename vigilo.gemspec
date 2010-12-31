# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vigilo/version"

platform = ENV["BUILD_PLATFORM"]

Gem::Specification.new do |s|
  s.name        = "vigilo"
  s.version     = Vigilo::VERSION
  s.platform    = platform || Gem::Platform::RUBY
  s.authors     = ["Yehuda Katz"]
  s.email       = ["wycats@gmail.com"]
  s.homepage    = "http://www.yehudakatz.com"
  s.summary     = %q{Watches the file system for changes}
  s.description = %q{Quis custodiet ipsos custodes?}

  s.rubyforge_project = "vigilo"

  if platform =~ /darwin/
    s.add_dependency "ruby-fsevent", "~> 0.2.1"
  end

  s.add_development_dependency "rspec", "~> 2.3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
