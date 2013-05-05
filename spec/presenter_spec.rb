# encoding: UTF-8

require 'helper'

TestPresenter = Keynote::Presenter

describe Keynote::Presenter do
  describe "delegation" do
    let(:klass) do
      Class.new(TestPresenter) do
        presents :grizzly, :bear
        delegate :adams, :to => :grizzly
        delegate :man, :to => :grizzly, :prefix => true
      end
    end

    it "should be able to use ActiveSupport Module#delegate method" do
      mock = mock()
      mock.expects(:adams)
      mock.expects(:man)

      klass.new(nil, mock, nil).tap do |p|
        p.adams
        p.grizzly_man
      end
    end
  end

  describe ".presents" do
    it "should take just the view context by default" do
      klass = Class.new(TestPresenter)

      klass.new(1).instance_variable_get(:@view).must_equal 1
    end

    describe "with two parameters" do
      let(:klass) do
        Class.new(TestPresenter) do
          presents :grizzly, :bear
        end
      end

      it "should let you specify other objects to take" do
        klass.new(1, 2, 3).instance_eval do
          @view.must_equal 1
          @grizzly.must_equal 2
          @bear.must_equal 3
        end
      end

      it "should not be callable with the wrong arity" do
        proc { klass.new(1, 2) }.must_raise ArgumentError
      end

      it "should generate readers for the objects" do
        klass.new(1, 2, 3).tap do |p|
          p.view.must_equal 1
          p.grizzly.must_equal 2
          p.bear.must_equal 3
        end
      end
    end
  end

  describe ".use_html5_tags" do
    let(:klass) do
      Class.new(TestPresenter) do
        include Keynote::Rumble

        def generate_h3(content)
          build_html { h3 content }
        end

        def generate_small(content)
          build_html { small content }
        end
      end
    end

    it "should add Rumble tags like `small` while preserving existing tags" do
      presenter = klass.new(nil)

      presenter.generate_h3("hi").must_equal "<h3>hi</h3>"
      proc { presenter.generate_small("uh-oh") }.must_raise NoMethodError

      klass.use_html_5_tags

      presenter.generate_h3("hi").must_equal "<h3>hi</h3>"
      presenter.generate_small("hi").must_equal "<small>hi</small>"
    end
  end

  describe ".object_names" do
    it "doesn't leak between classes" do
      c1 = Class.new(Keynote::Presenter)
      c2 = Class.new(Keynote::Presenter)

      c1.object_names << :foo
      c1.object_names.must_equal [:foo]
      c2.object_names.must_equal []
    end

    it "matches the list of presented objects" do
      c = Class.new(Keynote::Presenter)
      c.object_names.must_equal []
      c.presents :biff, :bam, :pow
      c.object_names.must_equal [:biff, :bam, :pow]
    end
  end

  describe "#present" do
    it "should pass its view context through to the new presenter" do
      mock = mock()
      mock.expects(:pizza)

      p1 = TestPresenter.new(mock)
      p2 = p1.present(:test)

      p1.wont_equal p2
      p2.pizza
    end
  end

  describe "#inspect" do
    it "includes the class name" do
      CombinedPresenter.new(:view, :a, :b).inspect.
        must_match /^#<CombinedPresenter /
    end

    it "shows .inspect output for each presented object" do
      c1 = Class.new(Object) { def inspect; "c1"; end }
      c2 = Class.new(Object) { def inspect; "c2"; end }
      p  = CombinedPresenter.new(:view, c1.new, c2.new)

      p.inspect.must_equal "#<CombinedPresenter model_1: c1, model_2: c2>"
    end

    it "shouldn't leave extra padding for zero-arg presenters" do
      EmptyPresenter.new(:view).inspect.must_equal "#<EmptyPresenter>"
    end
  end

  describe "#method_missing" do
    it "should pass unknown method calls through to the view" do
      mock = mock()
      mock.expects(:talking).with(:heads)

      object = Class.new do
        define_method(:talking) do |arg|
          mock.talking(arg)
        end
        private :talking
      end.new

      TestPresenter.new(object).talking(:heads)
    end

    it "should respond_to? methods of the view" do
      object = Class.new do
        define_method(:talking) do |arg|
        end
        private :talking
      end.new

      TestPresenter.new(object).respond_to?(:talking).must_equal true
    end

    it "should raise unknown methods at the presenter, not the view" do
      err = nil

      begin
        TestPresenter.new(Object.new).talking(:heads)
      rescue NoMethodError => e
        err = e
      end

      err.wont_be_nil
      err.message.must_match /#<Keynote::Presenter/
    end
  end
end
