# encoding: UTF-8

module Keynote
  module Controller
    def present(*args)
      Keynote.present(view_context, *args)
    end
  end
end
