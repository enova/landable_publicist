Publicist.ThemeDeactivateController = Ember.ObjectController.extend

  actions:
    deactivate: ->
      adapter = @get('model.adapter')
      theme = @get('model')
      url = adapter.buildURL('theme', theme.id)

      request = adapter.ajax url, 'DELETE'

      request.then ->
        Publicist.messages.add 'Successfully trashed.', level: 'success', title: 'Trashed'
        theme.rollback()
        theme.reload()

        $('.modal:visible').modal('hide')

      request.then null, ->
        Publicist.messages.add 'Trashed was not successful.', level: 'error', title: 'Not Trashed'
