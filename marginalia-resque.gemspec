# -*- encoding: utf-8 -*-
require File.expand_path('../lib/marginalia-resque/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Burke Libbey"]
  gem.email         = ["burke@burkelibbey.org"]
  gem.description   = %q{Extends Marginaila to log Job class names and parameters when running queries from a Resque job.}
  gem.summary       = %q{Extends Marginalia to report on Resque jobs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "marginalia-resque"
  gem.require_paths = ["lib"]
  gem.version       = Marginalia::Resque::VERSION

  gem.add_dependency 'marginalia', '>= 1.1.0'
  gem.add_dependency 'resque'
end
