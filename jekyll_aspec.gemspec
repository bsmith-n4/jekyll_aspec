
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_aspec/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll_aspec'
  spec.version       = JekyllAspec::VERSION
  spec.authors       = ['bsmith-n4']
  spec.email         = ['brian.smith@numberfour.eu']

  spec.summary       = 'Asciidoctor extensions for use as a Jekyll plugin'
  spec.description   = 'This plugin is a group of Asciidoctor extensions that perform directory walking,
                          resolving the location of titles and anchors in all adoc files so that inter-document
                          cross-references in a Jekyll project are resolved automatically. Also included are some
                          custom macros and blocks that are useful for techinical writing.'
  spec.homepage      = 'https://github.com/bsmith-n4/jekyll_aspec'
  spec.license       = 'MIT'

  # This gem will work with 2.0 or greater.
  spec.required_ruby_version = '>= 2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.15.4'
  spec.add_development_dependency 'rake', '>= 12.1.0'
  spec.add_development_dependency 'test-unit', '>=3.2.6'
  spec.add_runtime_dependency 'asciidoctor', '>= 1.5.0'
end
