# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'katagami/version'

Gem::Specification.new do |spec|
  spec.name          = "katagami"
  spec.version       = Katagami::VERSION
  spec.authors       = ["hshimoyama"]
  spec.email         = ["h.shimoyama@gmail.com"]

  spec.summary       = "A toolkit for building form objects."
  spec.description   = "A toolkit for building form objects."
  spec.homepage      = "https://github.com/hshimoyama/katagami"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "activerecord"

  spec.add_dependency "axiom"
  spec.add_dependency "virtus"
  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
end
