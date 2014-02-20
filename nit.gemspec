# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nit/version'

Gem::Specification.new do |spec|
  spec.name          = "nit"
  spec.version       = Nit::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]
  spec.description   = %q{Improving your Git workflow since 2013.}
  spec.summary       = %q{Nit improves your git workflows.}
  spec.homepage      = "http://github.com/apotonick/nit"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = %w(nit)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.18.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "5.2.0"
end
