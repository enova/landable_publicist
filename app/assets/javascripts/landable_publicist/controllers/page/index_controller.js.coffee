Publicist.PageIndexController = Publicist.EditorIndexController.extend

  availableCategories:              (-> Publicist.get('availableCategories')).property()
  activeThemes:                     (-> @store.filter 'theme', (record) -> record.get('deletedAt') == null).property()

  suggestedRedirectUrlWithProtocol: (->
    "http://#{@get('redirectUrl')}"
  ).property('model.redirectUrl')

  suggestedRedirectUrlWithSlash:    (->
    "/#{@get('redirectUrl')}"
  ).property('model.redirectUrl')

  redirectUrlLooksIffy:             (->
    @get('redirectUrl') and not /^[a-z]+\:\/\//.test(@get('redirectUrl')) and not /^\//.test(@get('redirectUrl'))
  ).property('model.redirectUrl')

  actions:
    applySuggestedRedirectUrl: (url) ->
      @set 'model.redirectUrl', url
