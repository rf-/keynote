# encoding: UTF-8

require 'helper'

describe Keynote do
  let(:view)  { Object.new }

  describe "with a normal presenter" do
    let(:model) { Normal.new }

    it "should find and instantiate implicitly" do
      p = Keynote.present(view, model)

      p.wont_be_nil
      p.must_be_instance_of NormalPresenter

      p.view.must_equal  view
      p.model.must_equal model
    end

    it "should find and instantiate explicitly" do
      p = Keynote.present(view, :normal, 'hello')

      p.wont_be_nil
      p.must_be_instance_of NormalPresenter

      p.view.must_equal  view
      p.model.must_equal 'hello'
    end

    it "should take a block and pass the presenter into it" do
      m = mock()
      m.expects(:block_yielded)

      Keynote.present(view, :normal, 'hello') do |p|
        m.block_yielded

        p.wont_be_nil
        p.must_be_instance_of NormalPresenter

        p.view.must_equal  view
        p.model.must_equal 'hello'
      end
    end

    it "should integrate with Rumble" do
      p  = Keynote.present(view, model)
      rx = /<div>&lt;script&gt;alert\(/

      p.some_bad_html.scan(rx).count.must_equal 3
    end
  end

  describe "with a nested presenter" do
    let(:model) { Keynote::Nested.new }

    it "should find and instantiate implicitly" do
      p = Keynote.present(view, model)

      p.wont_be_nil
      p.must_be_instance_of Keynote::NestedPresenter

      p.view.must_equal  view
      p.model.must_equal model
    end

    it "should find and instantiate explicitly" do
      p = Keynote.present(view, "keynote/nested", 'hello')

      p.wont_be_nil
      p.must_be_instance_of Keynote::NestedPresenter

      p.view.must_equal  view
      p.model.must_equal 'hello'
    end
  end

  describe "caching" do
    describe "when there is a view context" do
      let(:view_2) { Object.new }

      it "should cache based on the models" do
        model_1 = Normal.new
        model_2 = Normal.new

        presented_1 = Keynote.present(view, model_1)
        presented_2 = Keynote.present(view, model_1)

        presented_1.must_be :equal?, presented_2

        presented_3 = Keynote.present(view, :combined, model_1, model_2)
        presented_4 = Keynote.present(view, :combined, model_1, model_2)
        presented_5 = Keynote.present(view, :combined, model_2, model_1)

        presented_3.wont_be :equal?, presented_1
        presented_3.must_be :equal?, presented_4
        presented_3.wont_be :equal?, presented_5
      end

      it "should cache even if there are no models" do
        presenter_1 = Keynote.present(view, :empty)
        presenter_2 = Keynote.present(view, :empty)

        presenter_1.must_be :equal?, presenter_2
      end

      it "should be scoped to the specific view context" do
        model = Normal.new

        presenter_1 = Keynote.present(view, model)
        presenter_1.view.must_equal view

        presenter_2 = Keynote.present(view_2, model)
        presenter_2.wont_be :equal?, presenter_1
        presenter_2.view.must_equal view_2
      end
    end

    describe "when there's no view context" do
      it "shouldn't cache" do
        model_1 = Normal.new
        model_2 = Normal.new

        presented_1 = Keynote.present(nil, model_1)
        presented_2 = Keynote.present(nil, model_1)

        presented_1.wont_be :equal?, presented_2
      end
    end
  end
end
