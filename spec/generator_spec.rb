# encoding: UTF-8

require 'helper'
require 'rails/generators'
require 'fileutils'

describe "generators" do
  def invoke_generator(*args)
    FileUtils.mkdir_p(output_path)

    args.push '--quiet'

    retval = Rails::Generators.invoke 'presenter', args,
      :behavior => :invoke,
      :destination_root => output_path

    assert retval, 'Generator must succeed'

    output_files = Dir["#{output_path}/**/*.rb"]

    yield output_files.map { |path| path.sub("#{output_path}/", '') }.sort
  ensure
    FileUtils.rm_rf(output_path)
  end

  def output_path
    File.expand_path('../../tmp', __FILE__)
  end

  def file_contents(path)
    file_contents = File.read(File.join(output_path, path))
  end

  describe "when the test_framework is :test_unit" do
    before do
      Rails.application.config.generators do |g|
        g.test_framework :test_unit
      end
    end

    it "generates a presenter and Test::Unit file" do
      invoke_generator 'post' do |files|
        files.must_equal %w(
          app/presenters/post_presenter.rb
          test/unit/presenters/post_presenter_test.rb
        )

        file_contents('app/presenters/post_presenter.rb').
          must_match /class PostPresenter < Keynote::Presenter/

        file_contents('test/unit/presenters/post_presenter_test.rb').
          must_match /class PostPresenterTest < Keynote::TestCase/
      end
    end

    it "does not add a 'presents' line" do
      invoke_generator 'post' do |files|
        file_contents('app/presenters/post_presenter.rb').
          wont_match /presents/
      end
    end

    it "generates an appropriate present() call" do
      invoke_generator 'post' do |files|
        file_contents('test/unit/presenters/post_presenter_test.rb').
          must_match /present\(:post\)/
      end
    end

    describe "when the presenter has one parameter" do
      it "adds a 'presents' line" do
        invoke_generator 'post', 'foo' do |files|
          file_contents('app/presenters/post_presenter.rb').
            must_match /presents :foo$/
        end
      end

      it "generates an appropriate present() call" do
        invoke_generator 'post', 'foo' do |files|
          file_contents('test/unit/presenters/post_presenter_test.rb').
            must_match /present\(:post, :foo\)/
        end
      end
    end

    describe "when the presenter has two parameters" do
      it "adds a 'presents' line" do
        invoke_generator 'post', 'foo', 'bar' do |files|
          file_contents('app/presenters/post_presenter.rb').
            must_match /presents :foo, :bar$/
        end
      end

      it "generates an appropriate present() call" do
        invoke_generator 'post', 'foo', 'bar' do |files|
          file_contents('test/unit/presenters/post_presenter_test.rb').
            must_match /present\(:post, :foo, :bar\)/
        end
      end
    end
  end

  it "generates a presenter and RSpec file" do
    Rails.application.config.generators do |g|
      g.test_framework :rspec
    end

    invoke_generator 'post' do |files|
      files.must_equal %w(
        app/presenters/post_presenter.rb
        spec/presenters/post_presenter_spec.rb
      )

      file_contents('app/presenters/post_presenter.rb').
        must_match /class PostPresenter < Keynote::Presenter/

      file_contents('spec/presenters/post_presenter_spec.rb').
        must_match /describe PostPresenter do/
    end
  end

  it "generates a presenter and MiniTest::Rails spec file" do
    Rails.application.config.generators do |g|
      g.test_framework :mini_test, :spec => true
    end

    invoke_generator 'post' do |files|
      files.must_equal %w(
        app/presenters/post_presenter.rb
        test/presenters/post_presenter_test.rb
      )

      file_contents('app/presenters/post_presenter.rb').
        must_match /class PostPresenter < Keynote::Presenter/

      file_contents('test/presenters/post_presenter_test.rb').
        must_match /describe PostPresenter do/
    end
  end

  it "generates a presenter and MiniTest::Rails unit file" do
    Rails.application.config.generators do |g|
      g.test_framework :mini_test, :spec => false
    end

    invoke_generator 'post' do |files|
      files.must_equal %w(
        app/presenters/post_presenter.rb
        test/presenters/post_presenter_test.rb
      )

      file_contents('app/presenters/post_presenter.rb').
        must_match /class PostPresenter < Keynote::Presenter/

      file_contents('test/presenters/post_presenter_test.rb').
        must_match /class PostPresenterTest < Keynote::TestCase/
    end
  end
end
