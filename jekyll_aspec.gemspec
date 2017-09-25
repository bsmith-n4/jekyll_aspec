
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll_aspec/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll_aspec"
  spec.version       = JekyllAspec::VERSION
  spec.authors       = ["bsmith-n4"]
  spec.email         = ["brian.smith@numberfour.eu"]

  spec.summary       = %q{Asciidoctor extensions for use as a Jekyll plugin}
  spec.homepage      = "https://github.com/bsmith-n4/jekyll_aspec"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency "asciidoctor"
end
