Publicist.TemplatePublishController = Ember.ObjectController.extend

  revision: (->
    revision = @store.createRecord 'templateRevision'
    unless @get('model.publishedRevision')
      revision.set('notes', 'Initial version')
    revision
  ).property('model', 'model.publishedRevision')

  actions:
    publish: ->
      template = @get 'model'
      revision = @get 'revision'

      adapter = @get('model.adapter')
      url     = adapter.buildURL 'template', "#{template.id}/publish"

      request = adapter.ajax url, 'POST',
        data: adapter.serialize(revision, includeId: false)
        dataType: 'json'

      # success handler
      request.then ->
        Publicist.messages.add 'Successfully published.', title: 'Published', level: 'success'

        # Force Reload so that Triggered Page Revision is Visible!
        location.reload(true)

      # failure handler
      request.then null, ->
        Publicist.messages.add 'Publish was not successful.', title: 'Not Published', level: 'error'
