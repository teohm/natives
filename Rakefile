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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "natives-catalog"
  gem.homepage = "http://github.com/teohm/natives-catalog"
  gem.license = "MIT"
  gem.summary = %Q{Maintains a catalog of native library packages required by Ruby gems.}
  gem.description = %Q{Maintains a catalog of native library packages required by Ruby gems, and a parser to load catalog files. It can be extended to maintain additional catalogs e.g. for other package dependency manager such as npm.}
  gem.email = "teohuiming@gmail.com"
  gem.authors = ["Huiming Teo"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:coverage) do |spec|
  ENV['COVERAGE'] = 'true'
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
