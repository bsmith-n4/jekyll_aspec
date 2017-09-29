require 'bundler/gem_tasks'
require 'test/unit'

task :default => :test

task :test do
  ruby 'test/suite.rb'
  # Run separate test for HTML postprocessor
  ruby 'test/html_postprocessor.rb'
end
