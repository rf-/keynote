## v0.2.0pre1
* Add an implementation of the `present`/`k` method that's available in test
  cases. Update test generators accordingly.
* Update minitest-rails integration to be compatible with the newest
  version of minitest-rails (on Rails 3.0, 3.1, 3.2, and 4.0).
* Add `use_html_5_tags` class method to `Keynote::Presenter`. This adds a more
  complete set of Rumble tag methods to the class.

## v0.1.3
* Add block form of `present`. If you pass a block into a `present` call, it
  yields the presenter.
