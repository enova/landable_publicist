Publicist.AssetsIndexRoute = Ember.Route.extend
  model: -> @store.find 'asset'
