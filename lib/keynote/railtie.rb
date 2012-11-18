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
  end
end
