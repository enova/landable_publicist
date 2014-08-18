Publicist.AssetPanelController = Ember.ObjectController.extend

  searchTerm: ''

  searchResults: (->
    if searchTerm = @get('searchTerm')
      @store.find 'asset', search: { name: searchTerm }
    else
      []
  ).property('searchTerm')
