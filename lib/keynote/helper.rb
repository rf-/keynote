# encoding: UTF-8

module Keynote
  module Helper
    def present(*args)
      Keynote.present(self, *args)
    end
    alias p present
  end
end
