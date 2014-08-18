Publicist.EditorController = Ember.ObjectController.extend

  parentRoute: null

  actions:
    save: ->
      @get('model').save()

    reset: ->
      model = @get('model')

      if model.get('isNew')
        model.deleteRecord() and model.save() # commit
        @transitionToRoute(@get('parentRoute') or model.get('typeKey').pluralize())
      else
        model.send('rollback')
        Publicist.messages.add 'Your changes were discarded.', title: 'Canceled', level: 'info'

    copy: ->
      modelType = @get('model').constructor.typeKey
      modelProperties = switch modelType
        when 'page'
          body:         @get('model.body')
          theme:        @get('model.theme')
          statusCode:   @get('model.statusCode')
          redirectUrl:  @get('model.redirectUrl')
          title:        @get('model.title')
          metaTags:     @get('model.metaTags')
          category:     @get('model.category')
          headContent:  @get('model.headContent')

        when 'theme'
          body:         @get('model.body')
          description:  @get('model.description')
          thumbnailUrl: @get('model.thumbnailUrl')

        when 'template'
          body:         @get('model.body')
          description:  @get('model.description')
          thumbnailUrl: @get('model.thumbnailUrl')

      constructor = @get('model.constructor')
      modelCopy   = @store.createRecord modelType, modelProperties

      transition = @transitionToRoute modelType, modelCopy
      transition.then null, -> modelCopy.deleteRecord()
      Publicist.messages.add 'Successfully copied and loaded.', title: 'Copied', level: 'success'


Publicist.EditorIndexController = Ember.ObjectController.extend()


Publicist.EditorCodeController = Ember.ObjectController.extend

  availableTemplates: (-> @store.find 'template').property()

  availableTags: (->
    Publicist.Theme.availableTags if @get('model.isTheme')
  ).property('model')

  actions:
    createTemplate: ->
      template = @store.createRecord 'template',
        body: @get('model.body')
        description: "Based on \"#{@get('model.title')}\" (#{@get('model.path')})"
      transition = @transitionToRoute 'template', template

      # if we failed to transition, forget it, delete what we just made and move on already
      transition.then null, -> template.deleteRecord()


Publicist.EditorPreviewController = Ember.ObjectController.extend

  preview: ''
  errors: []

  setupPreview: ->
    type    = @get('model').constructor.typeKey
    adapter = @get('model.adapter')
    url     = adapter.buildURL(type, 'preview')

    data = {}
    data[type] = @get('model').serialize(includeId: true)

    request = adapter.ajax url, 'POST', data: data

    request.then (result) =>
      data = result[@get('model.typeKey')] || {}

      preview = data.preview

      if preview
        # adding a base tag to keep things sane
        preview  = preview.replace /<head>/, "<head><base href=/publicist>"

        # Trigger Preview Tab Styles
        preview = preview.replace /<body>/, "<body class='publicist-preview'>"
      else
        # tell the user something useful if the preview is empty
        preview = '<p style="color: #777; font-family: sans-serif; font-size: 12px;">Add some content in the Code tab before previewing.</p>'
      @set 'preview', preview

      errors = []
      for key, value of data.errors
        errors.push(key: key.capitalize(), value: value)
      @set 'errors', errors

    request.then null, ->
      Publicist.messages.add "There was an error generating the preview.", title: 'Preview failed!', level: 'error'

  teardownPreview: ->
    @set 'preview', null

  actions:
    mobile: ->
      $('iframe').width('480')

    tablet: ->
      $('iframe').width('768')

    laptop: ->
      $('iframe').width('990')

    desktop: ->
      $('iframe').width('1200')
