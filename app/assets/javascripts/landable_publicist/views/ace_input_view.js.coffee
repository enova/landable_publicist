Publicist.AceInputView = Ember.View.extend

  fontSize: '12px'
  theme: 'github'
  keybinding: 'ace'
  behavioursEnabled: false
  mode: 'html'
  readOnly: false

  configObserver: (->
    # font size
    @$().css('font-size', @get('fontSize'))

    # theme
    @editor.setTheme('ace/theme/' + @get('theme'))

    # keybinding
    @keyboard ?= @editor.getKeyboardHandler()
    if @get('keybinding') isnt 'ace'
      @editor.setKeyboardHandler('ace/keyboard/' + @get('keybinding'))
    else
      @editor.setKeyboardHandler(@keyboard)

    # setBehavioursEnabled (code completion)
    @editor.setBehavioursEnabled(@get('behavioursEnabled'))

    # mode
    current_mode = require('ace/mode/' + @get('mode')).Mode
    @session.setMode(new current_mode())

    # return focus
    @editor.focus()

    # readonly?
    @editor.setReadOnly(@get('readOnly'))
  ).observes('fontSize', 'theme', 'keybinding', 'mode', 'readOnly', 'behavioursEnabled')

  didInsertElement: ->
    # keep the right height
    @resizeElement()
    $(window).on 'resize.publicist.ace', => @resizeElement()

    @editor = ace.edit @get('element')

    # setup
    @editor.setDisplayIndentGuides(false)
    @editor.setShowInvisibles(false)
    @editor.setHighlightActiveLine(true)
    @editor.setFadeFoldWidgets(true)
    @editor.setShowFoldWidgets(true)
    @editor.setPrintMarginColumn(120)

    @session = @editor.getSession()
    current_mode = require('ace/mode/' + @get('mode')).Mode
    @session.setMode(new current_mode())
    @session.setUseWrapMode(true)
    @session.setUseSoftTabs(true)
    @session.setTabSize(2)

    @editor.setValue @get('value')
    @editor.navigateFileStart()

    @configObserver()

    # value updates
    @editor.on 'change', =>
      @withValueLock -> @set 'value', @editor.getValue()

  willDestroyElement: ->
    @editor.destroy()
    $(window).off 'resize.publicist.ace'

  valueUpdated: (->
    @withValueLock -> @editor.setValue @get('value')
  ).observes('value')

  withValueLock: (callback) ->
    unless @get 'valueLock'
      @set 'valueLock', true
      callback.apply this
      @set 'valueLock', false

  resizeElement: ->
    @$().height($(window).height() - @$().position().top - 235)

Publicist.AceInputView.reopenClass
  fontSizeOptions: [
    Ember.Object.create(value: '10px', label: '10'),
    Ember.Object.create(value: '11px', label: '11'),
    Ember.Object.create(value: '12px', label: '12'),
    Ember.Object.create(value: '14px', label: '14'),
    Ember.Object.create(value: '16px', label: '16'),
    Ember.Object.create(value: '20px', label: '20'),
  ]

  themeOptions: [
    Ember.Object.create(value: 'github', label: 'Standard'),
    Ember.Object.create(value: 'chaos', label: 'Chaos'),
    Ember.Object.create(value: 'dreamweaver', label: 'Dreamweaver'),
    Ember.Object.create(value: 'idle_fingers', label: 'Idle Fingers'),
    Ember.Object.create(value: 'monokai', label: 'Monokai'),
    Ember.Object.create(value: 'solarized_dark', label: 'Solarized Dark'),
    Ember.Object.create(value: 'tomorrow_night_blue', label: 'Tomorrow Night Blue '),
    Ember.Object.create(value: 'twilight', label: 'Twilight'),
  ]

  keybindingOptions: [
    Ember.Object.create(value: 'ace', label: 'Standard'),
    Ember.Object.create(value: 'emacs', label: 'Emacs'),
    Ember.Object.create(value: 'vim', label: 'Vim'),
  ]

  modeOptions: [
    Ember.Object.create(value: 'html', label: 'HTML'),
    Ember.Object.create(value: 'css', label: 'CSS'),
    Ember.Object.create(value: 'xml', label: 'XML'),
  ]

  behaviourOptions: [
    Ember.Object.create(value: true, label: 'On'),
    Ember.Object.create(value: false, label: 'Off')
  ]
