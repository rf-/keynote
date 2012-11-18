# encoding: UTF-8

module Keynote
  # `Keynote::Helper` is mixed into `ActionView::Base`, providing a `present`
  # method (aliased to `p`) for instantiating presenters.
  module Helper
    # Instantiate a presenter.
    # @see Keynote.present
    def present(*objects)
      Keynote.present(self, *objects)
    end
    alias p present
  end
end
