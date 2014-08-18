Publicist.PageReactivateController = Ember.ObjectController.extend

  actions:
    reactivate: ->
      adapter = @get('model.adapter')
      page = @get('model')
      url = adapter.buildURL('page', "#{page.id}/reactivate")

      request = adapter.ajax url, 'PUT'

      request.then ->
        Publicist.messages.add 'Successfully restored.', level: 'success', title: 'Restored'
        page.rollback()
        page.reload()

        $('.modal:visible').modal('hide')

      request.then null, ->
        Publicist.messages.add 'Restoration was not successful.', level: 'error', title: 'Not Restored'
