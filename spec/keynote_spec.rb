# encoding: UTF-8

require 'helper'

class NormalPresenter < Keynote::Presenter
  presents :model
end

class Normal
end

module Keynote
  class NestedPresenter < Keynote::Presenter
    presents :model
  end

  class Nested
  end
end

describe Keynote do
  describe "with a normal presenter" do
    let(:model) { Normal.new }

    it "should find and instantiate implicitly" do
      p = Keynote.present(:view, model)

      p.wont_be_nil
      p.must_be_instance_of NormalPresenter

      p.view.must_equal  :view
      p.model.must_equal model
    end

    it "should find and instantiate explicitly" do
      p = Keynote.present(:view, :normal, 'hello')

      p.wont_be_nil
      p.must_be_instance_of NormalPresenter

      p.view.must_equal  :view
      p.model.must_equal 'hello'
    end
  end

  describe "with a nested presenter" do
    let(:model) { Keynote::Nested.new }

    it "should find and instantiate implicitly" do
      p = Keynote.present(:view, model)

      p.wont_be_nil
      p.must_be_instance_of Keynote::NestedPresenter

      p.view.must_equal  :view
      p.model.must_equal model
    end

    it "should find and instantiate explicitly" do
      p = Keynote.present(:view, :"keynote/nested", 'hello')

      p.wont_be_nil
      p.must_be_instance_of Keynote::NestedPresenter

      p.view.must_equal  :view
      p.model.must_equal 'hello'
    end
  end
end
