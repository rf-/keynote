## v0.3.0
* Drop support for Rails 3.0 and Ruby 1.9.2; add support for Rails 4.2.
* Drop support for MiniTest::Rails versions older than 2.0; add support for 2.0
  and higher. (@kirs)

## v0.2.3
* Allow user to pass the string version of the presenter name into
  `Keynote.present` as an alternative to passing a symbol. This makes it less
  awkward to use namespaced presenters, but it does remove the possibility of
  defining a `StringPresenter` and using it with code like
  `k('some string').format_as_markdown`. It seems unlikely that anyone is
  actually doing that though. (@outpunk)
* Update RSpec integration to not print deprecation warnings with RSpec 3.
  (@DarthSim)

## v0.2.2
* Fix another RSpec integration bug, which happened in cases where the app's
  Gemfile included rspec-rails but not the rspec gem itself.
* Fix a bug in the generation of specs for zero-arg presenters.

## v0.2.1
* Update configuration to test across MRI 1.9.2/1.9.3/2.0.0/2.1.0, Rubinius,
  JRuby, Rails 3.0/3.1/3.2/4.0/4.1.
* Fix issue #6, in which the order of dependencies in the Gemfile could keep
  Keynote's RSpec integration from loading correctly.

## v0.2.0
* Add `Keynote::Inline`, a module that presenters can extend to enable inline
  templating in any language supported by Rails.
* Presenters now have a `use_html_5_tags` class method that adds a more
  complete set of Rumble tag methods to the class.
* Add `object_names` class method to presenters, returning an array of the
  symbols that have been passed into the `presents` method.
* Add an implementation of the `present`/`k` method that's available in test
  cases. Update test generators accordingly.
* Update minitest-rails integration to be compatible with the newest
  version of minitest-rails (on Rails 3.0, 3.1, 3.2, and 4.0).

## v0.1.3
* Add block form of `present`. If you pass a block into a `present` call, it
  yields the presenter.
