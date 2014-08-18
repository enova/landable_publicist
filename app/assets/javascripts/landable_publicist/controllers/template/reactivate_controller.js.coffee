Publicist.TemplateReactivateController = Ember.ObjectController.extend

  actions:
    reactivate: ->
      adapter = @get('model.adapter')
      template = @get('model')
      url = adapter.buildURL('template', "#{template.id}/reactivate")

      request = adapter.ajax url, 'PUT'

      request.then ->
        Publicist.messages.add 'Successfully restored.', level: 'success', title: 'Restored'
        template.rollback()
        template.reload()

        $('.modal:visible').modal('hide')

      request.then null, ->
        Publicist.messages.add 'Restoration was not successful.', level: 'error', title: 'Not Restored'
