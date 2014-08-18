Publicist.AssetUploadModal = Ember.View.extend
  templateName: 'asset_upload_modal'
  elementId: 'asset-upload-modal'
  classNames: ['modal', 'hide', 'fade']

  uploadDisabled: (->
    !@get('asset.file')? || @get('asset.name')?.length == 0
  ).property('asset.name', 'asset.file')

  init: ->
    @resetAsset()
    @_super

  resetAsset: ->
    if @get('asset.isNew')
      @get('asset').deleteRecord()

    asset = Publicist.store.createRecord 'asset'
    @set 'asset', asset

  didInsertElement: ->
    @set 'controller.assetUploader', this
    @$().on 'shown',  =>
      @set 'isOpen', true

    @$().on 'hidden', =>
      unless @get('isDestroyed')
        @set 'isOpen', false
        @resetAsset()

    # jury-rigged submit handler, since we're potentially inside someone else's <form>
    @$('button').click (e) =>
      # prevent this from bubbling up
      e.preventDefault()

      # onwards
      @submit()

  submit: (e) ->
    @get('asset').save().then (asset) =>
      Publicist.messages.add 'Your asset has been uploaded.', title: 'Saved!', level: 'success'
      @close()

      # janky. until there's a better way to have crosstalk between views, or
      # someone feels like coming up with a better way to model this, it'll
      # work. (sorry.)
      if panelView = Ember.View.views[$('.ember-view.asset-panel').attr('id')]
        panelView.set 'controller.searchTerm', asset.get('name')
        panelView.toggle()
      else
        @get('controller').send('transitionToRoute', 'asset', asset)

      @resetAsset()

    , (error) ->
      Publicist.messages.add 'There was an error uploading the asset.', title: 'Upload Error', level: 'error'

  show: ->
    @$().modal('show') unless @get 'isOpen'

  close: ->
    @$().modal('hide')
