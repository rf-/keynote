# encoding: UTF-8

require 'minitest/rails/action_view'

module Keynote
  module MiniTest
    class TestCase < ::MiniTest::Rails::ActionView::TestCase
      # describe SomePresenter do
      register_spec_type(self) do |desc|
        desc < Keynote::Presenter if desc.is_a?(Class)
      end

      # describe "SomePresenter" do
      register_spec_type(/presenter( ?test)?\z/i, self)

      # Don't try to include any particular helper, since we're not testing one
      def self.include_helper_modules!
        include _helpers
      end
    end
  end
end
