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
        # In Rails 4 this is kind of a weird place to generate tests into.
        # Unfortunately it isn't really fixable without changing the Rails
        # test tasks, so that's a TODO.
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

    def presenter_name_and_target_list
      [presenter_name, *target_names].join(', ')
    end

    def target_list
      target_names.join(', ')
    end

    def presenter_name
      class_name.sub(/Presenter$/, '').underscore.to_sym.inspect
    end

    def target_names
      targets.map { |t| ":#{t}" }
    end
  end
end
