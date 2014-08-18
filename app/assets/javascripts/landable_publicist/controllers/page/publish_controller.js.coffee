Publicist.PagePublishController = Ember.ObjectController.extend

  revision: (->
    revision = @store.createRecord 'pageRevision'
    unless @get('model.publishedRevision')
      revision.set('notes', 'Initial version')
    revision
  ).property('model', 'model.publishedRevision')

  actions:
    publish: ->
      page     = @get 'model'
      revision = @get 'revision'

      adapter = @get('model.adapter')
      url     = adapter.buildURL 'page', "#{page.id}/publish"

      request = adapter.ajax url, 'POST',
        data: adapter.serialize(revision, includeId: false)
        dataType: 'json'

      # success handler
      request.then ->
        Publicist.messages.add 'Successfully published.', title: 'Published', level: 'success'
        page.reload()

        # not fond of this, but I'm not sure of the best way to send an event to the view from here
        $('.modal:visible').modal('hide')

      # failure handler
      request.then null, ->
        Publicist.messages.add 'Publish was not successful.', title: 'Not Published', level: 'error'
