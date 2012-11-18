# encoding: UTF-8

class Keynote::NestedPresenterTest < Keynote::TestCase
  setup do
    @presenter = Keynote::NestedPresenter.new(view, :model)
  end

  test "presenter has view context" do
    assert_equal "<div id=\"hi\"><a href=\"Hello\">#</a></div>",
      @presenter.generate_div
  end
end
