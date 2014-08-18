Ember.Application.initializer
  name: 'messages'

  initialize: (container, app) ->
    app.set 'messages', Ember.Object.create(
      add: (content, options={}) ->
        options.text = content
        options.title ?= 'Heads up!'
        options.type = options.level
        options.delay ?= 1000

        # ignorable notifications should not interfere with the ui
        if ['success', 'info'].contains options.level
          options.nonblock ?= true
          options.nonblock_opacity = 0.3

        options.history = false
        options.icon = false
        options.opacity = 0.9

        $.pnotify options
    )
