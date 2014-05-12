require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'

Bundler.require
Bundler::GemHelper.install_tasks

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # nothing
end

task :default => :spec