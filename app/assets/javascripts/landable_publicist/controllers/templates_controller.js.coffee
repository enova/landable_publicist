Publicist.TemplatesIndexController = Publicist.ListViewController.extend
  filteredTemplates: (->
    filters = @get('filters')
    templates = @get('model')

    for filter in Ember.keys(filters)
      doFilter = switch filter
        when 'isDeactivated'
          !filters.get(filter)
        when 'category', 'theme', 'auditFlag'
          !!filters.get(filter)
        else
          false

      if doFilter
        if filter == 'auditFlag'
          templates = templates.filter (template) ->
            template.get('auditFlags').contains(filters.get(filter))
        else
          templates = templates.filterProperty filter, filters.get(filter)

    templates
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
    'model.templates',
    'filters',
    'filters.isDeactivated',
    'filters.category',
    'filters.theme',
    'filters.auditFlag',
  )
