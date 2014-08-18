# additions to DS.Model

DS.Model.reopen
  init: ->
    @_super()

    # hack to ensure that the typeKey is registered
    Publicist.__container__.lookupFactory('model:' + @constructor.toString().split('.').pop().camelize())

    # isPage, isAuthor, etc
    if @constructor.typeKey
      flag = "is#{@constructor.typeKey.capitalize()}"
      @set(flag, true) unless @get(flag)

    # until ember-data implements relationship handling for DirtyState,
    # (a la https://github.com/emberjs/data/issues/1188),
    # mark this as dirty if...
    @eachRelationship (name, relationship) =>
      if relationship.kind is 'belongsTo'
        # - the related thing is switched out
        @addObserver name, =>
          @adapterDidDirty() unless @_suspendedRelationships

        # - the related thing is itself dirtied
        @addObserver "#{name}.isDirty", =>
          if @get("#{name}.isDirty")
            @adapterDidDirty() unless @_suspendedRelationships

      else if relationship.kind is 'hasMany'
        # - the number of related things changes
        @addObserver "#{name}.[]", =>
          @adapterDidDirty() unless @_suspendedRelationships

        # - one of the related things becomes dirty
        @addObserver "#{name}.@each.isDirty", =>
          if @get(name).someProperty('isDirty')
            @adapterDidDirty() unless @_suspendedRelationships

  typeKey: (-> @constructor.typeKey).property()

  adapter: (-> @get('store').adapterFor @constructor).property().volatile()

  isClean:    (-> !@get('isDirty')).property('isDirty')
  isSaveable: (-> @get('isValid') and @get('isDirty')).property('isValid', 'isDirty')
  isNotSaveable: (-> !@get('isSaveable')).property('isSaveable')

  buildURL: (path) ->
    @constructor.buildURL(@get 'id') + (if path then "/#{path}" else '')

  # super will clear out local attribute updates, but not updates that are in
  # flight (such as those that we tried to commit, but perhaps were rejected
  # for being invalid). it also won't unset errors.
  rollback: ->
    if @get('errors')
      @eachAttribute (attribute) => @set "errors.#{attribute}", null
    @_inFlightAttributes = {}
    @_super()


DS.Model.reopenClass
  buildURL: (path = '') ->
    store = Publicist.__container__.lookup('store:main')
    adapter = store.adapterFor(@)
    adapter.buildURL adapter.pathForType(@), path
