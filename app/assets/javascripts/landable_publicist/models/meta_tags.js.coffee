# Meta tags are a little difficult right now. They come back from the server
# as a pretty ordinary hash, but because object assignment creates references
# (not copies), compounded by attribute changes not being automatic at that
# level, we're using MetaTags as a proxy class. Whenever its attributes
# change, the source data hash is replaced, wholesale. This simplifies a LOT
# of stuff.

# "But Isaac," you say, "wtf?"

# And to that I say that building proper support for complex attributes is
# completely not in scope right now.


Publicist.MetaTags = Ember.Object.extend

  # will have an incoming binding via the Page instance
  data: {}

  # helper for what lies below
  _dataProperty: (key, value) ->
    @set('data', {}) unless @get('data')
    
    if arguments.length > 1
      newData = {}
      Ember.merge(newData, @get('data'))
      newData[key] = value
      @set('data', newData)

    @get('data')[key]


  # these two are pretty standard, passing the arguments through. note that
  # ember cares about what arguments actually are passed in, and since
  # uglifier tries to remove unused arguments, we need a noop reference to
  # both key and value.

  description: ((key, value) ->
    Ember.K(key, value) # noop, see above
    @_dataProperty.apply @, arguments
  ).property('data')

  keywords: ((key, value) ->
    Ember.K(key, value) # noop, see above
    @_dataProperty.apply @, arguments
  ).property('data')


  # this one is not
  robots: ((key, value) ->
    if arguments.length > 1
      # as a setter, this only accepts an array
      @_dataProperty key, value?.join(',')

    # as a getter, we return an array
    @get('data')[key]?.split(/, ?/) || []
  ).property('data')


  robotsProxy: (->
    Ember.ArrayProxy.create
      source: @
      contentBinding: 'source.robots'

      remove: (directive) ->
        set = new Ember.Set(@get('source.robots'))
        set.remove(directive)
        @set 'source.robots', set.toArray()

      add: (directive) ->
        set = new Ember.Set(@get('source.robots'))
        set.add(directive)
        @set 'source.robots', set.toArray()
  ).property()


Publicist.MetaTags.robotDirectives = [
  Ember.Object.create(name: 'noindex',   description: 'Hide from search results + noarchive.'),
  Ember.Object.create(name: 'nofollow',  description: 'Do not follow links on this page.'),
  Ember.Object.create(name: 'noarchive', description: 'No "Cached" link in search results.'),
  Ember.Object.create(name: 'nosnippet', description: 'No description below page in search result + noarchive.'),
  Ember.Object.create(name: 'noodp',     description: 'Prevents Open Directory Project description from being used.'),
  Ember.Object.create(name: 'noydir',    description: 'Prevents Yahoo! Directory description from being used.')
]
