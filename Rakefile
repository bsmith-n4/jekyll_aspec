require 'bundler/gem_tasks'
require 'test/unit'

task :default => :test

task :test do
  ruby 'test/suite.rb'
  ruby 'test/html_postprocessor.rb'
  ruby 'test/convert_doc.rb'

end

task :rubocop do
  sh 'rubocop'
  sh 'htmlproofer test'
end
