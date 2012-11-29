# encoding: UTF-8

module Keynote
  # `Keynote::Controller` is mixed into `ActionController::Base` and
  # `ActionMailer::Base`, providing a `present` method (aliased to `k`) for
  # instantiating presenters.
  module Controller
    # Instantiate a presenter.
    # @see Keynote.present
    def present(*objects)
      Keynote.present(view_context, *objects)
    end
    alias k present
  end
end
