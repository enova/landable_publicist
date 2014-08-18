Publicist.TemplateDeactivateController = Ember.ObjectController.extend

  actions:
    deactivate: ->
      adapter = @get('model.adapter')
      template = @get('model')
      url = adapter.buildURL('template', template.id)

      request = adapter.ajax url, 'DELETE'

      request.then ->
        Publicist.messages.add 'Successfully trashed.', level: 'success', title: 'Trashed'
        template.rollback()
        template.reload()

        $('.modal:visible').modal('hide')

      request.then null, ->
        Publicist.messages.add 'Trashed was not successful.', level: 'error', title: 'Not Trashed'
