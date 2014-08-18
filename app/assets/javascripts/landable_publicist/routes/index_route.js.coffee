Publicist.IndexRoute = Ember.Route.extend

  # the dashboard does nothing useful right now.
  redirect: -> @transitionTo 'directories'
