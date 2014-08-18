Publicist.ThemesNewRoute = Ember.Route.extend

  activate: ->
    theme = @store.createRecord 'theme'
    @transitionTo 'theme', theme