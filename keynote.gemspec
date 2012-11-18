# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keynote/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Fitzgerald"]
  gem.email         = ["rwfitzge@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "keynote"
  gem.require_paths = ["lib"]
  gem.version       = Keynote::VERSION

  gem.add_dependency 'rails', '>= 3.0.0'

  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'yard'
end
