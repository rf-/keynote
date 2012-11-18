# encoding: UTF-8

module Keynote
  module ExampleGroup
    def self.included(base)
      base.send :include, RSpec::Rails::ViewExampleGroup
      base.metadata[:type] = :presenter
    end
  end
end

RSpec.configure do |config|
  config.include Keynote::ExampleGroup,
    :type => :presenter,
    :example_group => {:file_path => %r/spec.presenters/}
end
