# encoding: UTF-8

require 'rails/railtie'

module Keynote
  # @private
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      add_presenters_to_paths(app)
      load_test_integration
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

    def self.add_presenters_to_paths(app)
      if ::Rails.version.to_f >= 4
        app.config.paths.add 'app/presenters'
      else
        app.config.paths.add 'app/presenters', :eager_load => true
      end
    end

    def self.load_test_integration
      if defined?(RSpec::Rails)
        require 'keynote/testing/rspec'
      end

      if defined?(MiniTest::Rails)
        require 'keynote/testing/minitest_rails'
      end

      if !defined?(MiniTest::Rails)
        require "keynote/testing/test_unit"
      end
    end
  end
end
