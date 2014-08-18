Publicist.DirectoriesDirectoryController = Publicist.ListViewController.extend

  filteredPages: (->
    filters = @get('filters')
    pages   = @get('model.pages')

    for filter in Ember.keys(filters)
      doFilter = switch filter
        # negative filters
        when 'isRedirect', 'isMissing', 'isOkay', 'isDeactivated'
          !filters.get(filter)

        # positive filters
        when 'category', 'theme', 'auditFlag'
          !!filters.get(filter)

        else
          false

      if doFilter
        if filter == 'auditFlag'
          pages = pages.filter (page) ->
            page.get('auditFlags').contains(filters.get(filter))
        else
          pages = pages.filterProperty filter, filters.get(filter)



    pages
  ).property('_filterTick')

  _needsRefiltering: (->
    # set a flag to refilter on the next run loop
    unless @get('_willRefilter')
      @set '_willRefilter', true

      Ember.run.schedule 'sync', this, ->
        # if we're still in the game, trigger the refilter
        unless @get('isDestroyed')
          @set '_willRefilter', false
          @set '_filterTick', (@get('_filterTick') + 1)
  ).observes(
    'model',
    'model.pages.@each.statusCode',
    'filters',
    'filters.isDeactivated',
    'filters.isMissing',
    'filters.isOkay',
    'filters.isRedirect',
    'filters.category',
    'filters.theme',
    'filters.auditFlag',
  )
