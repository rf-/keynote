require "minitest_helper"

describe <%= class_name %>Presenter do
  before do
    @presenter = <%= class_name %>Presenter.new(<%= view_and_target_list %>)
  end

  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
end
