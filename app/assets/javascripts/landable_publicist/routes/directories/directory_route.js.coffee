Publicist.DirectoriesDirectoryRoute = Ember.Route.extend

  activate: ->
    # since this is a routing shortcut, keep this in the router and not the view
    $(window).on 'keydown.publicist.searchRedirect', (e) =>
      # T redirects to search
      if e.keyCode is 84
        @transitionTo 'pages.search'

  deactivate: ->
    $(window).off 'keydown.publicist.searchRedirect'

  model: (params) ->
    @store.find 'directory', '/' + params.directory_id.replace(/^\//, '')

  setupController: (controller, model) ->
    model.reload() if model.get('isLoaded') and not model.get('isReloading')
    controller.set 'model', model

  serialize: (model) ->
    # sometimes this method is called out of context. I don't know why.
    if model.constructor is Publicist.Directory
      # temporary hack until we get this sorted out between publicist and landable
      directory_id: model.get('id')?.replace(/%2F/g, '/').replace(/^\//, '')
