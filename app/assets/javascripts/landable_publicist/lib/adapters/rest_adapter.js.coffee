Publicist.RESTAdapter = DS.RESTAdapter.extend
  headers: (->
    {
      'Accept': 'application/json',
      'Authorization': @get('authorization'),
    }
  ).property('authorization')

  pathForType: (type) ->
    if type.constructor is String
      typeKey = type
    else
      typeKey = type.typeKey

    typeKey.underscore().pluralize()

  # see https://github.com/emberjs/data/issues/405 for why we're setting an id now
  generateIdForRecord: -> uuid.v4()

  # directory ids are their paths, and need to be encoded when building a url
  # (e.g. %2Ffoo%2Fbar vs /foo/bar)
  buildURL: (type, id) ->
    if id and type is 'directory'
      id = encodeURIComponent id

    @_super type, id

  _flattenHash: (hash, marker, rehash) ->
    rehash ?= {}

    for own key, value of hash
      if marker
        rekey = "#{marker}[#{key}]"
      else
        rekey = key

      if value?.constructor is Object
        @_flattenHash(value, rekey, rehash)
      else
        rehash[rekey] = value

    rehash

  _containsFile: (hash) ->
    for own key, value of hash
      if value instanceof File
        return true
      else if value?.constructor is Object
        if @_containsFile(value)
          return true

  ajax: (url, type, hash = {}) ->
    # go multipart if a file is present
    if @_containsFile(hash.data)
      formData = new FormData

      for key, value of @_flattenHash(hash.data)
        formData.append key, value

      hash.data = formData
      hash.processData = false
      hash.contentType = false

    new Ember.RSVP.Promise (resolve, reject) =>
      hash.url = url
      hash.type = type
      hash.dataType = 'json'
      hash.context = @

      if hash.data and type isnt 'GET' and (hash.processData or hash.processData is undefined)
        hash.contentType = 'application/json; charset=utf-8'
        hash.data = JSON.stringify(hash.data)

      hash.beforeSend = (xhr) =>
        for key, value of @get('headers')
          xhr.setRequestHeader key, value

      hash.success = (json) ->
        Ember.run(null, resolve, json)

      hash.error = (jqXHR, textStatus, errorThrown) =>
        Ember.run(null, reject, @ajaxError(jqXHR))

      Ember.$.ajax(hash)

  ajaxError: (jqXHR) ->
    return unless jqXHR?

    jqXHR.then = null

    # extract json, if any
    try
      json = JSON.parse jqXHR.responseText

      # normalize the results
      serializer = Publicist.__container__.lookup('serializer:application')
      for key, value of json
        json[key] = serializer.normalizePayload(key, json[key])

    catch error
      throw error if error.constructor isnt SyntaxError
      json = null


    errorMessage = (title, message) ->
      Publicist.messages.add(
        "<a onclick=\"window.location.reload(); return false;\">#{message}</a>",
        title: title,
        hide: false,
        closer: false,
        level: 'error',
      )

    # handle it
    switch jqXHR.status

      # invalid
      when 422
        new DS.InvalidError json.errors

      # unauthorized
      when 401
        errorMessage 'Expired session', 'Click here to refresh and log in again.'

      # conflict
      when 409
        errorMessage 'Record save conflict', "The record has been updated by #{json.author.firstName} #{json.author.lastName}. Please reload the page."

      # wrong api version
      when 406
        errorMessage 'API error', 'There was a problem with the API. Click here to refresh.'

      # something else
      else
        jqXHR

