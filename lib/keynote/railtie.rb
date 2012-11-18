# encoding: UTF-8

require 'rails/railtie'

module Keynote
  # @private
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add 'app/presenters', :eager_load => true

      if defined?(RSpec::Rails) && RSpec.respond_to?(:configure)
        require 'keynote/testing/rspec'
      end

      if defined?(MiniTest::Rails)
        require 'keynote/testing/minitest_rails'
      end

      require "keynote/testing/test_unit"
    end

    ActiveSupport.on_load(:action_view) do
      include Keynote::Helper
    end

    ActiveSupport.on_load(:action_controller) do
      include Keynote::Controller
    end

    ActiveSupport.on_load(:action_mailer) do
      include Keynote::Controller
    end

    rake_tasks do
      if defined?(MiniTest::Rails)
        load File.expand_path("../testing/minitest_rails.rake", __FILE__)
      end
    end
  end
end
