require 'minitest_helper'

class <%= class_name %>PresenterTest < Keynote::MiniTest::TestCase
  setup do
    @presenter = <%= class_name %>Presenter.new(<%= view_and_target_list %>)
  end

  # test "the truth" do
  #   assert true
  # end
end
