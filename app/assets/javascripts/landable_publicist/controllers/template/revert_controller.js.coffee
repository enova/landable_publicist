Publicist.TemplateRevertController = Ember.ObjectController.extend
  needs: 'templateRevisions'

  template: null
  templateBinding: 'controllers.templateRevisions.model'

  revision: null
  revisionBinding: 'controllers.templateRevisions.targetTemplateRevision'  

  actions:
    revertTo: ->
      @get('template').rollback()

      adapter = @get('template.adapter')
      url     = adapter.buildURL 'templateRevision', "#{@get('revision.id')}/revert_to"

      request = adapter.ajax url, 'POST',
        dataType: 'json'

      request.then (result) =>
        @cancel()
        Publicist.messages.add 'Successfully loaded.', title: 'Loaded', level: 'success'
        @get('template').reload()

      request.then null, =>
        Publicist.messages.add 'Loading revision was unsuccessful.', title: 'Not loaded', level: 'error'
        @cancel()

  cancel: ->
    @set('revision', null)
    $('#revision-revert-modal').modal('hide')
