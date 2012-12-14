# encoding: UTF-8

module Keynote
  # `Keynote::Controller` is mixed into `ActionController::Base` and
  # `ActionMailer::Base`, providing a `present` method (aliased to `k`) for
  # instantiating presenters.
  module Controller
    # Instantiate a presenter.
    # @see Keynote.present
    def present(*objects, &blk)
      Keynote.present(view_context, *objects, &blk)
    end
    alias k present
  end
end
