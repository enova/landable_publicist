Publicist.PageRevertController = Ember.ObjectController.extend
  needs: 'pageRevisions'

  page: null
  pageBinding: 'controllers.pageRevisions.model'

  revision: null
  revisionBinding: 'controllers.pageRevisions.targetPageRevision'  

  actions:
    revertTo: ->
      @get('page').rollback()

      adapter = @get('page.adapter')
      url     = adapter.buildURL 'pageRevision', "#{@get('revision.id')}/revert_to"

      request = adapter.ajax url, 'POST',
        dataType: 'json'

      request.then (result) =>
        @cancel()
        Publicist.messages.add 'Successfully loaded.', title: 'Loaded', level: 'success'
        @get('page').reload()

      request.then null, =>
        Publicist.messages.add 'Loading revision was unsuccessful.', title: 'Not loaded', level: 'error'
        @cancel()

  cancel: ->
    @set('revision', null)
    $('#revision-revert-modal').modal('hide')
