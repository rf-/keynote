# encoding: UTF-8

require "keynote/testing/test_present_method"

module Keynote
  class TestCase < ::ActionView::TestCase
    include TestPresentMethod
  end
end
