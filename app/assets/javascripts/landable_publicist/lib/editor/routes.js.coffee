Publicist.EditorRoute = Ember.Route.extend

  actions:
    willTransition: (transition)  ->
      model = @get 'controller.model'

      currentRouteMatcher = new RegExp "^#{model.get('typeKey')}\\."
      unless transition.targetName.match currentRouteMatcher
        if model.get('isDirty') and not model.get('isDeleted')
          transition.abort()
          Publicist.messages.add 'Please save or cancel before leaving the editor.', title: "Unsaved #{model.get('typeKey')}", level: 'error'


Publicist.EditorSubroute = Ember.Route.extend
  model: ->
    # figure out what model we're dealing with. If this is ThemeIndexRoute, the model is "theme".
    modelType = @constructor.toString().match(/Publicist\.([A-Z][a-z]*)/)[1].toLowerCase()

    # we're inside a parent route that's already fetched the model, so go with that
    @modelFor modelType


Publicist.EditorIndexRoute = Publicist.EditorSubroute.extend()


Publicist.EditorCodeRoute = Publicist.EditorSubroute.extend()


Publicist.EditorPreviewRoute = Publicist.EditorSubroute.extend

  setupController: (controller, model) ->
    controller.set 'model', model
    controller.setupPreview()

  deactivate: ->
    @get('controller').teardownPreview()
