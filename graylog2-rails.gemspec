# -*- encoding: utf-8 -*-
require File.expand_path('../lib/graylog2-rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Artem Melnikov"]
  gem.email         = ["artem.melnikov@ignar.name"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://ignar.name"

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

  gem.add_development_dependency("rspec", "~> 2.0")
end
