# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "capistrano-secure-permissions"
  gem.homepage = "http://github.com/runephilosof/capistrano-secure-permissions"
  gem.license = "MIT"
  gem.summary = %Q{Sets ACL permissions after capistrano deployment}
  gem.description = %Q{This gem makes it easy to run your app with a user that only has write permissions to the public folder}
  gem.email = "rune.capistrano-secure-permissions@philosof.dk"
  gem.authors = ["Rune Schjellerup Philosof"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "capistrano-secure-permissions #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
