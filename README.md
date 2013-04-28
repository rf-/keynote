# Keynote

*Flexible presenters for Rails.*

[![Code Climate](https://codeclimate.com/github/rf-/keynote.png)](https://codeclimate.com/github/rf-/keynote)

A presenter is an object that encapsulates view logic. Like Rails helpers,
presenters help you keep complex logic out of your templates.

Keynote provides a consistent interface for defining and instantiating
presenters.

## Usage

### The basic idea

A simple case is making a presenter that's named after a model class and holds
helper methods related to that model.

``` ruby
# app/presenters/user_presenter.rb

class UserPresenter < Keynote::Presenter
  presents :user

  def display_name
    "#{user.first_name} #{user.last_name}"
  end

  def profile_link
    link_to user, display_name, data: {user_id: user.id}
  end
end
```

You can then instantiate it by calling the `present` method (aliased to `k`) in
a view, helper, controller, or another presenter.

``` erb
<%# app/layouts/_header.html.erb %>

<div id="header">
  ...
  <div class="profile_link">
    <%= k(current_user).profile_link %>
  </div>
</div>
```

If you pass anything other than a symbol as the first parameter of
`present`/`k`, Keynote will assume you want to instantiate a presenter named
after the class of that object -- in this case, the model is a `User`, so
Keynote looks for a class called `UserPresenter`.

### Generating HTML

To make it easier to generate slightly more complex chunks of HTML, Keynote
includes a modified version of Magnus Holm's [Rumble](https://github.com/judofyr/rumble)
library. Rumble gives us a simple block-based syntax for generating HTML
fragments. Here's a small example:

``` ruby
build_html do
  div :id => :content do
    h1 'Hello World', :class => :main
  end
end
```

Becomes:

``` html
<div id="content">
  <h1 class="main">Hello World</h1>
</div>
```

You can use tag helpers like `div`, `span`, and `a` only within a block passed
to the `build_html` method. The `build_html` method returns a safe string. See
[the documentation for `Keynote::Rumble`](http://rubydoc.info/gems/keynote/Keynote/Rumble)
for more information.

### A more complex example

Let's add to our original example by introducing a named presenter. In addition
to `UserPresenter`, which has general-purpose methods for displaying the User
model, we'll create `HeaderPresenter`, which has methods that are specific to
the `layouts/header` partial.

``` ruby
# app/presenters/header_presenter.rb

class HeaderPresenter < Keynote::Presenter
  presents :user

  def profile_or_login_link
    if logged_in? # defined in a helper
      profile_link
    else
      login_link
    end
  end

  def profile_link
    build_html do
      div class: 'profile_link' do
        k(user).profile_link
      end
    end
  end

  def login_link
    build_html do
      div class: 'login_link' do
        link_to 'Log In', login_url
      end
    end
  end
end
```

``` erb
<%# app/layouts/_header.html.erb %>

<% header = present(:header, current_user) %>

<div id="header">
  ...
  <%= header.profile_or_login_link %>
</div>
```

We've avoided putting a conditional in the template, and we've also avoided
exposing the `profile_or_login_link` method to other parts of the app that
shouldn't need to care about it. It's located in a class that's specific to
this context.

### Delegating to models

If you want to delegate some calls on the presenter to one of the presenter's
underlying objects, it's easy to do it explicitly with ActiveSupport's
`delegate` API.

``` ruby
# app/presenters/user_presenter.rb

class UserPresenter < Keynote::Presenter
  presents :user
  delegate :first_name, :last_name, :to => :user

  def display_name
    "#{first_name} #{last_name}"
  end
end
```

You can also generate prefixed methods like `user_first_name` by passing
`:prefix => true` to the `delegate` method.

## Rationale

### Why use presenters or decorators at all?

The main alternative is to use helpers. Helpers are fine for many use cases --
Rails' built-in tag and form helpers are great. They have some drawbacks,
though:

* Every helper method you write gets mixed into the same view object as the
  built-in Rails helpers, URL generators, and all the other junk that comes
  along with `ActionView::Base`. In a freshly-generated Rails project:

  ```ruby
  >> ApplicationController.new.view_context.public_methods.count
  => 318
  >> ApplicationController.new.view_context.private_methods.count
  => 119
  ```

* Helpers can't have state that isn't "global" relative to the view, which
  can make it hard to write helpers that work together.

* By default, every helper is available in every view. This makes it difficult
  to set boundaries between different parts of your app and organize your view
  code cleanly.

### Why not use decorators?

The biggest distinction between Keynote and similar libraries like
[Draper](https://github.com/drapergem/draper) and
[DisplayCase](https://github.com/avdi/display-case) is that Keynote
presenters aren't decorators -- undefined method calls don't
fall through to an underlying model.

Applying the Decorator pattern to generating views is a reasonable thing to do.
However, this practice also has some downsides.

* Decorators make the most sense when there's exactly one object that's
  relevant to the methods you want to encapsulate. They're less helpful when
  you want to do things like define a class whose responsibility is to help
  render a specific part of your user interface, which may involve bringing in
  data from multiple models or collections.

* When reading code that uses decorators, it often isn't obvious if a given
  method is defined on the decorator or the underlying model, especially when
  the decorator is applied in the controller instead of the view.

* Passing decorated models between controllers and views can make it unclear
  whether a view (especially a nested partial) depends on a model having some
  specific decorator applied to it. This makes refactoring view and decorator
  code harder than it needs to be.

## Generators

Keynote doesn't automatically generate presenters when you generate models or
resources. To generate a presenter, you can use the `presenter` generator,
like so:

``` bash
$ rails g presenter FooBar foo bar
      create  app/presenters/foo_bar_presenter.rb
      create  spec/presenters/foo_bar_presenter_spec.rb
```

That project uses RSpec, but the generator can also create test files for
Test::Unit or MiniTest::Rails if applicable.

## Compatibility

Keynote is supported on Rails 3.0, 3.1, 3.2, and 4.0. Keynote presenters are
testable with Test::Unit, RSpec, and MiniTest::Rails.

If you find problems with any of the above integrations, please open an issue.

## Development

You can run Keynote's tests across all supported versions of Rails as follows:

``` bash
$ bundle install
$ rake appraisal:gemfiles
$ rake appraisal:install
$ rake appraisal
```

Feel free to submit pull requests according to the usual conventions for Ruby
projects.
