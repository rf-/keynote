# encoding: UTF-8

require 'helper'

describe Keynote::Railtie do
  let(:controller) { HelloController.new }
  let(:context)    { controller.view_context }

  it "should make the present method available to controllers" do
    controller.must_respond_to :present
  end

  it "should make the present and p methods available to views" do
    context.must_respond_to :present
    context.must_respond_to :p
  end

  it "should pass present call from controller to Keynote.present" do
    context = stub
    controller.stubs(:view_context).returns(context)

    Keynote.expects(:present).with(context, :dallas, :leeloo, :multipass)

    controller.present(:dallas, :leeloo, :multipass)
  end

  it "should pass present call from view to Keynote.present" do
    Keynote.expects(:present).with(context, :dallas, :leeloo, :multipass)

    context.present(:dallas, :leeloo, :multipass)
  end
end
