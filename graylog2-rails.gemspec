# -*- encoding: utf-8 -*-
require File.expand_path('../lib/graylog2-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Artem Melnikov"]
  gem.email         = ["artem.melnikov@ignar.name"]
  gem.description   = %q{Wrapper for Graylog2 logging system}
  gem.summary       = %q{Wrapper for Graylog2 logging system}
  gem.homepage      = "https://github.com/ignar/graylog2-rails"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "graylog2-rails"
  gem.require_paths = ["lib"]
  gem.version       = Graylog2Rails::VERSION

  gem.add_dependency("gelf", "~> 1.3.2")
  gem.add_dependency("awesome_print")
  gem.add_dependency("activesupport")
  gem.add_dependency("rake")

  gem.add_development_dependency "rails", ">= 3.2.0"
  gem.add_development_dependency "rspec", "~> 2.0"
  gem.add_development_dependency "pry"
end
