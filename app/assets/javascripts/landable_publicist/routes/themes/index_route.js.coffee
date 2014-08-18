Publicist.ThemesIndexRoute = Ember.Route.extend
  model: -> @store.find 'theme'
