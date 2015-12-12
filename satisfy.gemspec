# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'satisfy/version'

Gem::Specification.new do |spec|
  spec.name          = 'satisfy'
  spec.version       = Satisfy::VERSION
  spec.authors       = ['Jeff Nyman']
  spec.email         = ['jeffnyman@gmail.com']

  spec.summary       = %q{Executable Test Specifications with RSpec}
  spec.description   = %q{
    Satisfy is a micro-framework supports the creation and execution of test
    specifications that are written with the Gherkin structural language.
  }
  spec.homepage      = 'https://github.com/jnyman/satisfy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.requirements  << 'RSpec, Gherkin'

  spec.required_ruby_version     = '>= 2.0'
  spec.required_rubygems_version = '>= 1.8.29'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'

  spec.add_runtime_dependency 'rspec'
  spec.add_runtime_dependency 'gherkin'

  spec.post_install_message = %{
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  Satisfy #{Satisfy::VERSION} has been installed.
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  }
end
