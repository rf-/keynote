require 'spec_helper'

describe <%= class_name %>Presenter do
  subject { <%= class_name %>Presenter.new(<%= view_and_target_list %>) }
end
