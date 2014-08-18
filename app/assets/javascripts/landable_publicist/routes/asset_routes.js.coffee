Publicist.AssetRoute = Publicist.EditorRoute.extend

  # Apparently the empty hasMany relationships on asset (page, theme)
  #  are causing it to set as dirty upon opening the asset.  This automatically
  #  sends the rollback command, which correctly deactivates the save/reset buttons.
  afterModel: (model, transition) ->
    Ember.run.next ->
      model.send('rollback')

Publicist.AssetIndexRoute = Publicist.EditorIndexRoute.extend()
