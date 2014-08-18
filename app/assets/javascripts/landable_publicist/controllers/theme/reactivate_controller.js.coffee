Publicist.ThemeReactivateController = Ember.ObjectController.extend

  actions:
    reactivate: ->
      adapter = @get('model.adapter')
      theme = @get('model')
      url = adapter.buildURL('theme', "#{theme.id}/reactivate")

      request = adapter.ajax url, 'PUT'

      request.then ->
        Publicist.messages.add 'Successfully trashed.', level: 'success', title: 'Trashed'
        theme.rollback()
        theme.reload()

        $('.modal:visible').modal('hide')

      request.then null, ->
        Publicist.messages.add 'Trashed was not successful.', level: 'error', title: 'Not Trashed'
