# activates bootstrap js components
Ember.Application.initializer
  name: 'bootstrap'

  initialize: (container, app) ->

    # there doesn't seem to be a good way to search specific view elements
    # without also catching child view elements. thus, we use scheduleOnce to
    # check the root element itself at most once per run loop whenever a new
    # view's element is inserted.
    #
    # could also set up a view mixin, but this'll do for now.

    $rootElement = $(app.get 'rootElement')

    enableBootstrap = ->
      # tooltips
      # $rootElement.find('[data-toggle=tooltip]:not([data-original-title])').tooltip(container: $rootElement)

    Ember.View.reopen
      didInsertElement: ->
        Ember.run.scheduleOnce 'afterRender', this, enableBootstrap
