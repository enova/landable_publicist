Publicist.AuditsController = Ember.ObjectController.extend
  audit: (->
    @store.createRecord 'audit'
  ).property('audit')

  audits: (->
    @store.find 'audit'
  ).property('audits')

  auditsForModel: (->
    @store.find 'audit', auditable_id: @get('model.id')
  ).property('model')

  actions:
    createAudit: ->
      model = @get 'model'

      audit   = @get 'audit'
      adapter = @get 'audit.adapter'

      if model.isPage
        url     = adapter.buildURL 'pages', "#{model.id}/audits"
      else
        url     = adapter.buildURL 'templates', "#{model.id}/audits"

      request = adapter.ajax url, 'POST',
        data: adapter.serialize(audit, includeId: false)
        dataType: 'json'

      # success handler
      request.then ->
        # not fond of this, but I'm not sure of the best way to send an event to the view from here
        $('.modal:visible').modal('hide')

        Publicist.messages.add 'Successfully Audited.', title: 'Audit Created', level: 'success'

        # Force Page Reload to See New Audit!
        location.reload(true)

      # failure handler
      request.then null, ->
        if $('.approver-input').val() == ''
          $('.approver').css('color', 'red')
        Publicist.messages.add 'Audit was not successful.', title: 'Not Audited', level: 'error'
