# encoding: UTF-8

require "keynote/version"
require "keynote/rumble"
require "keynote/presenter"
require "keynote/controller"
require "keynote/helper"
require "keynote/railtie"
require "keynote/cache"

module Keynote
  class << self
    def present(view, *objects)
      if objects[0].is_a?(Symbol)
        name = objects.shift
      else
        name = presenter_name_from_object(objects[0])
      end

      Cache.fetch(name, view, *objects) do
        presenter_from_name(name).new(view, *objects)
      end
    end

    private

    def presenter_name_from_object(object)
      object.class.to_s.underscore
    end

    def presenter_from_name(name)
      "#{name.to_s.camelize}Presenter".constantize
    end
  end
end
