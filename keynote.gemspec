# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keynote/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Fitzgerald"]
  gem.email         = ["rwfitzge@gmail.com"]
  gem.summary       = %q{Flexible presenters for Rails.}
  gem.description   = %q{
    A presenter is an object that encapsulates view logic. Like Rails helpers,
    presenters help you keep complex logic out of your templates. Keynote
    provides a consistent interface for defining and instantiating presenters.
  }.gsub(/\s+/, ' ')
  gem.homepage      = "https://github.com/rf-/keynote"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "keynote"
  gem.require_paths = ["lib"]
  gem.version       = Keynote::VERSION

  gem.add_dependency 'rails', '>= 3.1.0'

  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'mocha', '~> 1.0.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'yard'

  gem.add_development_dependency 'slim'
  gem.add_development_dependency 'haml'

  unless RbConfig::CONFIG['ruby_install_name'] == 'jruby'
    gem.add_development_dependency 'redcarpet'
  end
end
