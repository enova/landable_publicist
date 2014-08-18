Publicist.TemplatesNewRoute = Ember.Route.extend

  activate: ->
    template = @store.createRecord 'template',
      body: "<p>Your content here!</p>"

    @transitionTo 'template', template