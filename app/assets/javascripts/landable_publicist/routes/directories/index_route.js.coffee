Publicist.DirectoriesIndexRoute = Ember.Route.extend

  activate: ->
    rootDirectory = @store.find 'directory', '/'
    @transitionTo 'directories.directory', rootDirectory

