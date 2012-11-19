# encoding: UTF-8

module Rails::Generators
  class PresenterGenerator < Rails::Generators::NamedBase
    desc "This generator creates a Keynote::Presenter subclass in " \
        "app/presenters."

    argument :targets, :type => :array, :default => []

    check_class_collision :suffix => 'Presenter'
    source_root File.expand_path('../templates', __FILE__)

    def create_presenter_file
      template 'keynote_presenter.rb',
        File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
    end

    def create_test_file
      case Rails.application.config.generators.rails[:test_framework]
      when :rspec
        template 'keynote_rspec.rb', rspec_path
      when :test_unit
        template 'keynote_test_unit.rb', test_unit_path
      when :mini_test
        if Rails.application.config.generators.mini_test[:spec]
          template 'keynote_mini_test_spec.rb', mini_test_path
        else
          template 'keynote_mini_test_unit.rb', mini_test_path
        end
      end
    end

    private

    def rspec_path
      File.join(
        'spec/presenters', class_path, "#{file_name}_presenter_spec.rb")
    end

    def test_unit_path
      File.join(
        'test/unit/presenters', class_path, "#{file_name}_presenter_test.rb")
    end

    def mini_test_path
      File.join(
        'test/presenters', class_path, "#{file_name}_presenter_test.rb")
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

    if ::Rails.version.to_f < 3.1
      protected
      # This methods doesn't exist in Rails 3.0
      def module_namespacing
        yield if block_given?
      end
    end
  end
end
