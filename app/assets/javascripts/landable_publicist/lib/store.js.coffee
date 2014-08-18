#= require ./adapters/landable_adapter

Publicist.Store = DS.Store.extend
  adapter: Publicist.LandableAdapter

  # When loading many records at once, chunk the operation into at most
  # @findManyLimit records per request.
  fetchManyLimit: 25
  fetchMany: (records, owner, resolver) ->
    promises = []

    for i in [0..(records.length-1)] by @fetchManyLimit
      subresolver = Ember.RSVP.defer()
      promises.push(resolver.promise)

      @_super(records[i..(i+@fetchManyLimit-1)], owner, subresolver)

    if resolver
      Ember.RSVP.all(promises).then(resolver.resolve, resolver.reject)

  # Don't want to generate an ID for new assets to avoid a
  # javascript error when the asset is a duplicate and landable
  # returns the original ID
  _generateId: (type) ->
    @_super(type) unless type is Publicist.Asset