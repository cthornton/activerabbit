# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_rabbit/version'

Gem::Specification.new do |spec|
  spec.name          = "activerabbit"
  spec.version       = ActiveRabbit::VERSION
  spec.authors       = ['Christopher Thornton']
  spec.email         = ['rmdirbin@gmail.com']
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'msgpack',       '~> 0.5'
  spec.add_dependency 'amqp',          '~> 1.5'

  spec.add_development_dependency 'rspec', '~> 3.1'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
