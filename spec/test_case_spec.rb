# encoding: UTF-8

class TestCaseSpecPresenter < Keynote::Presenter
  def generate_div
    html do
      div.hi! do
        link_to '#', 'Hello'
      end
    end
  end
end

class TestCaseSpecPresenterTest < Keynote::TestCase
  setup do
    @presenter = TestCaseSpecPresenter.new(view)
  end

  test "presenter has view context" do
    assert_equal "<div id=\"hi\"><a href=\"Hello\">#</a></div>",
      @presenter.generate_div
  end
end
