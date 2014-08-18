Publicist.PagesNewRoute = Ember.Route.extend

  # for the time being, create the local record and redirect immediately to
  # #/pages/:page_id.
  activate: ->
    page = @store.createRecord 'page'
    @transitionTo 'page', page
