Publicist.PageRevisionsController = Ember.ObjectController.extend

  revisions: (->
    @store.find 'pageRevision', page_id: @get('model.id')
  ).property('model.id', 'model.publishedRevision')

  actions:
    setTargetPageRevision: (pageRevision) ->
      @set('targetPageRevision', pageRevision)

    revertTo: (pageRevision) ->
      @get('model').rollback()

      adapter = @get('model.adapter')
      url     = adapter.buildURL 'pageRevision', "#{pageRevision.id}/revert_to"

      request = adapter.ajax url, 'POST',
        dataType: 'json'

      request.then (result) =>
        Publicist.messages.add 'Successfully loaded.', title: 'Loaded', level: 'success'
        @get('model').reload()

      request.then null, ->
        Publicist.messages.add 'Attempt to load revision was unsuccessful.', title: 'Not Loaded', level: 'error'
