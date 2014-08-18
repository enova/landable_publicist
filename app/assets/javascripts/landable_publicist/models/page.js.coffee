Publicist.Page = DS.Model.extend

  revisions:         DS.hasMany('pageRevision', async: true, readOnly: true)
  audits:            DS.hasMany('audit', async: true, readOnly: true)

  publishedRevision: DS.belongsTo('pageRevision', readOnly: true)
  isPublishable:     DS.attr('boolean', readOnly: true)
  isPublished:       (-> !!@get('publishedRevision')).property('publishedRevision')

  path:              DS.attr()
  title:             DS.attr()
  lockVersion:       DS.attr('number')
  statusCode:        DS.attr('number')
  abstract:          DS.attr()
  heroAssetName:     DS.attr('string')
  deletedAt:         DS.attr('string')

  # leaving the default value undefined so we can distinguish between a new body and an empty body
  body:              DS.attr('string', defaultValue: undefined)
  headContent:       DS.attr('string')
  auditFlags:        DS.attr('raw', defaultValue: [])

  redirectUrl:       DS.attr()
  previewPath:       DS.attr('string', readOnly: true)
  # previewUrl:   Update so doesn't use old site environment 

  theme:             DS.belongsTo('theme')
  category:          DS.belongsTo('category')
  updatedByAuthor:   DS.belongsTo('author')

  # bit hackish; see Publicist.MetaTags
  metaTags:          DS.attr('raw', defaultValue: {})
  metaTagsProxy:     (-> Publicist.MetaTags.create page: @, dataBinding: 'page.metaTags').property()

  name:              (-> @get('path')?.split('/').pop()).property('path')
  # url:               (-> @get('siteEnvironment').publicUrl @get('path')).property('siteEnvironment', 'path')

  # Check type of status code based on first digit
  isRedirect:        (-> @get('statusCode')?.toString()[0] == '3').property('statusCode')
  isMissing:         (-> @get('statusCode')?.toString()[0] == '4').property('statusCode')
  isOkay:            (-> @get('statusCode')?.toString()[0] == '2').property('statusCode')

  # the extension is a series of at least two word characters, preceded by a period, that terminate the string
  pathExtension:     (-> @get('path')?.match(/\.(\w{2,})$/)?[1]).property('path')
  isHtml:            (-> @get('pathExtension') in ['html', 'htm', null, undefined]).property('pathExtension')

  # checking for a deactivated item
  isDeactivated:     (-> !!@get('deletedAt')).property('deletedAt')

  directory: (->
    if @get('path')
      @store.find 'directory', @get('path').replace(/\/[^\/]*$/, '').replace(/^$/, '/')
    else
      @store.find 'directory', '/'
  ).property('path')

  categoryId: ((key, value) ->
    # getter
    if arguments.length is 1
      @get('category.id')

    # setter
    else
      # fetch the category from cache (to keep this synchronous), then set
      # either the instance or null (to avoid setting any undefineds)
      category = Publicist.get('availableCategories').filterProperty('id', value)[0]
      if category?.get('id') isnt @get('category.id')
        @set('category', category or null)

      @get('category.id')

  ).property('category')

  init: ->
    @_super()

    # set relationship defaults
    @one 'didLoad', @, ->

      # new pages are uncategorized by default.
      unless @get('category')
        @set 'category', Publicist.get('availableCategories').filterProperty('name', 'Uncategorized')[0]

Publicist.Page.reopenClass
  attributes: (->
    attributes = @_super()

    # FEATURE blogging (landable 1.6.0)
    if Publicist.features.get('bloggingDisabled')
      attributes.remove 'abstract'
      attributes.remove 'heroAssetName'

    attributes
  ).property('Publicist.features.bloggingDisabled')

Publicist.Page.statusCodes = [
  Ember.Object.create(code: 200, label: '200 OK'),
  Ember.Object.create(code: 301, label: '301 Permanent Redirect'),
  Ember.Object.create(code: 302, label: '302 Temporary Redirect'),
  Ember.Object.create(code: 410, label: '410 Gone'),
]
