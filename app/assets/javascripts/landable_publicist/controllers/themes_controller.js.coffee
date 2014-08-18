Publicist.ThemesIndexController = Publicist.ListViewController.extend

  filteredThemes: (->
    filters = @get('filters')
    themes = @get 'model'

    for filter in Ember.keys(filters)
      doFilter = switch filter
        when 'isDeactivated'
          !filters.get(filter)
        when 'category', 'theme'
          !!filters.get(filter)
        else
          false

      if doFilter
        themes = themes.filterProperty filter, filters.get(filter)

    themes
  ).property('_filterTick')

  _needsRefiltering: (->
    unless @get('_willRefilter')
      @set '_willRefilter', true

      Ember.run.schedule 'sync', this, ->
        unless @get('isDestroyed')
          @set '_willRefilter', false
          @set '_filterTick', (@get('_filterTick') + 1)
  ).observes(
    'model',
    'model.themes',
    'filters',
    'filters.isDeactivated',
    'filters.category',
    'filters.theme'
  )
