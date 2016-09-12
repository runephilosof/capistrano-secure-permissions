# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: capistrano-secure-permissions 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-secure-permissions"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Rune Schjellerup Philosof"]
  s.date = "2016-09-12"
  s.description = "This gem makes it easy to run your app with a user that only has write permissions to the public folder"
  s.email = "rune.capistrano-secure-permissions@philosof.dk"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "capistrano-secure-permissions.gemspec",
    "lib/capistrano/secure-permissions.rb",
    "lib/capistrano/tasks/secure-permissions.rake",
    "lib/secure-permissions.rb"
  ]
  s.homepage = "http://github.com/runephilosof/capistrano-secure-permissions"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Sets ACL permissions after capistrano deployment"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
    else
      s.add_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 4.2"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
  end
end

