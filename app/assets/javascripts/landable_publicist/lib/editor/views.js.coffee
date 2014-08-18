Publicist.EditorView = Ember.View.extend
  classNames: ['editor']
  classNameBindings: ['resourceType']
  modelBinding: 'controller.model'

  resourceType: (->
    @get('model.type')
  ).property('model')

  templateName: '_editor/wrapper'

  didInsertElement: ->
    @_setupMessengers()
    @_resizeBox()

    $(window).on 'resize.publicist.editor', => @_resizeBox()

    @$().on 'click.publicist.external_preview', 'a.preview i', (e) =>
      e.stopImmediatePropagation()
      e.preventDefault()

      window.open @get('model.previewUrl'), '_blank'

  willDestroyElement: ->
    @_teardownMessengers()

    $(window).off 'resize.publicist.editor'
    @$().off 'click.publicist.external_preview'


  _resizeBox: ->
    box = @$('.box')
    actions = @$('.form-actions')

    if box.length and actions.length
      box.css('min-height', actions.offset().top - box.offset().top)

  _modelMessengers:
    didCreate: ->
      Publicist.messages.add "The #{@get('model.typeKey')} was created.", title: 'Saved', level: 'success'
    didUpdate: ->
      Publicist.messages.add "The #{@get('model.typeKey')} was updated.", title: 'Saved', level: 'success'
    becameInvalid: ->
      Publicist.messages.add "Failed to save the #{@get('model.typeKey')}! Please check your input.", title: 'Error', level: 'error'
    becameError: ->
      # at the moment this messaging is handled by the adapter - see Publicist.RestAdapter
      # Publicist.messages.add 'Unknown error.', title: 'Error', level: 'error'

  _setupMessengers: (->
    if @get('state') is 'inDOM'
      model = @get 'model'
      for event, messenger of @_modelMessengers
        model.on event, @, messenger
  ).observes('model')

  _teardownMessengers: ->
    model = @get 'model'
    for event, messenger of @_modelMessengers
      model.off event, @, messenger

  keyDown: (e) ->
    # cmd+s or ctrl+s
    if (e.metaKey or e.ctrlKey) and e.keyCode is 83
      e.preventDefault()
      @get('controller').send('save')

  click: (e) ->
    # ctrl- or shift-clicking "Preview" opens the preview URL in a new window
    if @get('model.previewUrl')
      if (e.shiftKey or e.ctrlKey or e.metaKey) and $(e.target).is('.nav li a:contains("Preview")')
        e.preventDefault()
        window.open @get('model.previewUrl')


Publicist.EditorCodeView = Ember.View.extend

  templateName: '_editor/code'

  # control visibility of some sections in the sidebar
  showAssets: (-> @get('controller.model.isPage') or @get('controller.model.isTheme')).property('controller.model')
  showTemplates: (-> @get('controller.model.isPage')).property('controller.model')

  showLayouts: (->
    # layouts are shown for pages with an undefined or null body. note - not
    # the same as an empty body (i.e. ""), thus allowing users to empty out
    # the body without triggering the layout prompt.
    @get('controller.model.isPage') and not @get('controller.model.body')?
  ).property('controller.model', 'controller.model.body')

  fontSize: '12px'
  theme: 'github'
  keybinding: 'ace'
  behavioursEnabled: false
  mode: ((key, value) ->
    if arguments.length > 1
      @set('_mode', value)

    value ?= @get('_mode')
    value ?= @get('controller.model.pathExtension')

    switch value
      when undefined, null, 'htm', 'html'
        'html'
      when 'xml', 'css', 'json'
        value
      else
        'text'
  ).property('controller.model.pathExtension')
  readOnly: (->
    # not all models supply the `editable` property
    (@get('controller.model.editable') is false)
  ).property('controller.model.editable')

  # remember font size, theme, and keybindings
  rememberConfigObserver: (->
    for key in ['fontSize', 'theme', 'keybinding']
      $.cookie "publicist.editor.#{key}", @get(key), expires: 7, path: '/'
  ).observes('fontSize', 'theme', 'keybinding')

  # recall font size, theme, and keybindings
  init: ->
    @_super()
    for key in ['fontSize', 'theme', 'keybinding']
      if $.cookie("publicist.editor.#{key}")
        @set key, $.cookie("publicist.editor.#{key}")

  didInsertElement: ->
    @$('.assets-browse :file').on 'change', (e) ->
      $('#asset-file').fileupload 'add', fileInput: $(this)


    view = this

    # templates and tags
    @$().on 'click', 'a[data-code]', (e) ->
      e.preventDefault()
      view.get('childViews').filterProperty('editor')[0].get('editor').insert $(this).data('code')

    # layout templates
    @$().on 'click', '.code-layouts .thumbnail', (e) ->
      e.preventDefault()
      view.set 'controller.model.body', $(this).data('template')

    # resetting the body, triggering the layout prompt
    @$().on 'click', '.start-over', (e) ->
      e.preventDefault()
      view.set 'old_body', view.get 'controller.model.body'
      view.set 'controller.model.body', undefined

    # cancels decision to start new layout, reverts back to what was in code tab
    @$().on 'click', '.cancel-changes', (e) ->
      e.preventDefault()
      view.set 'controller.model.body', view.get 'old_body'
      view.set 'old_body', null

Publicist.EditorPreviewView = Ember.View.extend

  templateName: '_editor/preview'

  didInsertElement: ->
    # full-height iframe
    @$('iframe').iframeAutoHeight()
