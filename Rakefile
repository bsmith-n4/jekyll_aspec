require 'bundler/audit/task'
require 'bundler/gem_tasks'
require 'test/unit'

Bundler::Audit::Task.new

task default: :test

task :test do
  ruby 'test/suite.rb'
  ruby 'test/html_postprocessor.rb'
  ruby 'test/convert_doc.rb'
end

task :rubocop do
  sh 'rubocop'
  sh 'htmlproofer test'
end

task audit: 'bundle:audit'

desc 'Run tests, perform security audit of dependencies and ruby style check'
task :full do
  Rake::Task["test"].invoke
  Rake::Task["audit"].invoke
  Rake::Task["rubocop"].invoke
end
