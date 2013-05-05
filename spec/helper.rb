# encoding: UTF-8

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'

require 'pry'

require 'rails'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

require 'keynote'

## Initialize our test app (by Jose Valim: https://gist.github.com/1942658)

class TestApp < Rails::Application
  config.active_support.deprecation = :log
  config.eager_load = false

  config.secret_token = 'a' * 100
end

class HelloController < ActionController::Base
  def world
    render :text => "Hello world!", :layout => false
  end
end

TestApp.initialize!

# We have to define this class because it's hard-coded into the definition of
# ActiveSupport::TestCase, which will load regardless of whether we load
# ActiveRecord.
module ActiveRecord
  class Model
  end
end

## Examples

class EmptyPresenter < Keynote::Presenter
end

class NormalPresenter < Keynote::Presenter
  include Keynote::Rumble
  presents :model

  def some_bad_js
    "<script>alert('pwnt');</script>"
  end

  def some_bad_html
    build_html do
      div { text some_bad_js }
      div { some_bad_js }
      div some_bad_js
    end
  end
end

class Normal
end

module Keynote
  class NestedPresenter < Keynote::Presenter
    include Keynote::Rumble
    presents :model

    def generate_div
      build_html do
        div.hi! do
          link_to '#', 'Hello'
        end
      end
    end
  end

  class Nested
  end
end

class CombinedPresenter < Keynote::Presenter
  presents :model_1, :model_2
end
