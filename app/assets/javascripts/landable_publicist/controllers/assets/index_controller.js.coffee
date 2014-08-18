Publicist.AssetsIndexController = Ember.ArrayController.extend

  # Search currently relies on all assets being loaded here, rather
  # than repeatedly querying the remote API. That will probably be
  # unacceptable in the future, but suffices for now.

  actions:
    toggleSortDirection: ->
      @toggleProperty 'sortAscending'
      return null # avoid returning true, which would bubble the event

    transitionToRoute: (route, asset) ->
      @transitionToRoute route, asset

  filters: Ember.Object.create
    isImage: true
    isDocument: true
    isOther: true

  searchTerm: ''

  # we only sort by a single property at a time, so set up sortProperties as a
  # property based on that
  sortProperty: null
  sortProperties: (-> [@get('sortProperty')] if @get('sortProperty')).property('sortProperty')
  sortAscending: false

  # patch - occasionally this is requested despite no sorting being active
  orderBy: (item1, item2) -> @_super(item1, item2) if @get('isSorted')

  arrangedContent: (->
    # let SortableMixin handle sorting
    assets = @_super()

    # ensure we only have persisted assets
    assets = assets.rejectProperty('isNew')

    # filters
    filters = @get('filters')
    for filter in Ember.keys(filters)
      unless filters.get(filter)
        assets = assets.rejectProperty(filter)

    # seach terms
    term = @get('searchTerm')?.toLowerCase()
    if term?.length > 0
      assets = assets.filter (asset) -> asset.get('name').toLowerCase().indexOf(term) >= 0

    assets
  ).property(
   'searchTerm',
   'filters',
   'filters.isImage',
   'filters.isDocument',
   'filters.isOther',

   # SortableMixin uses these triggers
   'content', 'sortProperties.@each',
  )
