Publicist.PagesSearchController = Ember.Controller.extend

  searchPath: ''

  searchResults: (->
    if @get('searchPath')
      searchResults = @store.find 'page', search: {path: @get('searchPath')}
      searchResults.then =>
        @set 'searchMeta', @store.typeMapFor(Publicist.Page).metadata.search
      searchResults
    else
      []
  ).property('searchPath')

  searchMeta: {}

  back: ->
    window.history.back()

  createPage: ->
    page = @store.createRecord 'page', path: "/#{@get('searchPath')}"
    @transitionToRoute 'page', page
