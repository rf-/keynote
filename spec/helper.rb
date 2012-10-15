# encoding: UTF-8

require 'minitest/spec'
require 'minitest/autorun'
require 'mocha'

require 'pry'
require 'rails'
require 'rails/all'

require 'keynote'

# Initialize our test app (by Jose Valim: https://gist.github.com/1942658)

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
