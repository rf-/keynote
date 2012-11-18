# encoding: UTF-8

module Rails::Generators
  class PresenterGenerator < Rails::Generators::NamedBase
    desc "This generator creates a Keynote::Presenter subclass in " \
        "app/presenters."

    argument :targets, :type => :array, :default => []

    check_class_collision :suffix => 'Presenter'
    source_root File.expand_path('../templates', __FILE__)

    def create_presenter_file
      template 'presenter.rb',
        File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
    end

    def create_spec_file
      if current_test_framework == :rspec && defined?(RSpec::Rails)
        template 'rspec.rb',
          File.join(
            'spec/presenters', class_path, "#{file_name}_presenter_spec.rb")
      end
    end

    def create_test_unit_file
      if current_test_framework == :test_unit
        template 'test_unit.rb',
          File.join(
            'test/presenters', class_path, "#{file_name}_presenter_test.rb")
      end
    end

    private

    def current_test_framework
      Rails.application.config.generators.rails[:test_framework]
    end

    def target_list
      targets.map { |t| ":#{t}" }.join(', ')
    end

    def view_and_target_list
      if targets.any?
        ['view', target_list].join(', ')
      else
        'view'
      end
    end
  end
end
