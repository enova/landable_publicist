Ember.Application.initializer
  name: 'preloader'

  initialize: (container, app) ->
    app.deferReadiness()

    app.store = store = container.lookup('store:main')

    # Preload any landable-specific stuff. Doing this in the next run loop
    # to make sure the landable adapter is ready.
    Ember.run.next ->
      categories     =  store.find 'category'
      themes         =  store.find 'theme'
      configurations =  store.find 'configuration'

      Ember.RSVP.all([categories, themes, configurations]).then ([categories, themes, configurations]) ->
        app.set 'availableCategories', categories
        app.set 'availableThemes', themes
        app.set 'auditFlags', configurations.get('firstObject.auditFlags')

        app.advanceReadiness()

