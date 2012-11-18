# encoding: UTF-8

module Keynote
  # `Keynote::Cache` memoizes presenter instances, reducing the overhead of
  # calling `Keynote.present` repeatedly with the same parameters.
  module Cache
  end

  class << Cache
    # Return a cached presenter for the given parameters, or yield and cache
    # the block's return value for next time.
    #
    # The cached presenters are stored in an instance variable on the first of
    # the given objects, so they'll be garbage-collected when the associated
    # models go out of scope.
    #
    # @param [Symbol] name
    # @param [ActionView::Base] view
    # @param [Array] objects
    # @return [Keynote::Presenter]
    def fetch(name, view, *objects)
      first = objects.shift

      # If this is a zero-object presenter, we have to just instantiate it.
      if first.nil?
        return(yield)
      end

      # Otherwise, we can initialize our cache on the first of the presented
      # objects.
      if (cache = first.instance_variable_get(:@_keynote_cache)).nil?
        cache = {}
        first.instance_variable_set(:@_keynote_cache, cache)
      end

      # We key each entry by the name of the presenter and the object_id of
      # each of the other objects involved.
      key = [name, *objects.map(&:object_id)]

      # If we're using a cached presenter, update the view to match the one the
      # user passed in (in case the presenter was originally instantiated in
      # the controller or whatever).
      if (presenter = cache[key])
        presenter.view = view
      else
        presenter  = yield
        cache[key] = presenter
      end

      presenter
    end
  end
end
