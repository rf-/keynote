# encoding: UTF-8

require "rails"
require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "keynote"
require "benchmark"

class MyPresenter < Keynote::Presenter
  extend Keynote::Inline
  inline :erb

  def my_string
    "a" + "b" + "c"
  end

  def rumble
    a_local = 1000

    build_html do
      div.foobar.baz! do
        p { my_string }
        p { a_local }
      end
    end
  end

  def erb_hash
    a_local = 1000

    erb a_local: a_local
    # <div class="foobar" id="baz">
    #   <p><%= my_string %></p>
    #   <p><%= a_local %></p>
    # </div>
  end

  def erb_binding
    a_local = 1000

    erb binding
    # <div class="foobar" id="baz">
    #   <p><%= my_string %></p>
    #   <p><%= a_local %></p>
    # </div>
  end

  def raw_erb_template
    source = %{
      <div class="foobar" id="baz">
        <p><%= my_string %></p>
        <p><%= a_local %></p>
      </div>
    }
    template = ActionView::Template.new(
      source, "raw_erb_template",
      ActionView::Template.handler_for_extension(:erb),
      locals: [:a_local]
    )
    TESTS.times { template.render(self, a_local: 1000) }
  end
end

TESTS = 1_000
presenter = MyPresenter.new(:view)

Benchmark.bmbm do |results|
  results.report("rumble") { TESTS.times { presenter.rumble } }
  results.report("erb_hash") { TESTS.times { presenter.erb_hash } }
  results.report("erb_binding") { TESTS.times { presenter.erb_binding } }
  results.report("raw_erb_template") { presenter.raw_erb_template }
end
