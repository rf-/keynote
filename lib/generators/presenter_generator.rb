# encoding: UTF-8

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
end
