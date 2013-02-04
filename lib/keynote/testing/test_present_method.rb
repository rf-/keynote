# encoding: UTF-8

module Keynote
  module TestPresentMethod
    def present(*objects, &blk)
      Keynote.present(view, *objects, &blk)
    end
    alias k present
  end
end
