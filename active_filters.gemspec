
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_filters/version"

Gem::Specification.new do |spec|
  spec.name          = "active_filters"
  spec.version       = ActiveFilters::VERSION
  spec.authors       = ["Nathan Huberty"]
  spec.email         = ["nathan.huberty@gmail.com"]

  spec.summary       = "Map incoming controller parameters to named scopes in your models"
  spec.description   = "Map incoming controller parameters to named scopes in your models"
  spec.homepage      = "https://github.com/FidMe/active_filters"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "activerecord", ">= 4.2"
  spec.add_development_dependency "activesupport", ">= 4.2"
  spec.add_development_dependency "actionpack", ">= 4.2"
  spec.add_development_dependency "mocha", ">= 1.8.0"
end
