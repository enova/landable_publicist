# Currently assumes that its parent view will always be an
# AssetUploadModal, mostly to allow the modal to become visible
# automatically when a file is dropped onto the browser window.
#
# There may be an event-driven design that would be less coupled,
# but I haven't been able to find it yet.
Publicist.FileUploaderView = Ember.View.extend
  templateName: 'file_uploader'
  modalBinding: 'parentView'
  assetBinding: 'modal.asset'
  iconBinding:  'asset.iconName'

  hasFile:  (-> @get('asset.file')?).property('asset.file')
  filename: (-> @get('asset.file.name')).property('asset.file')

  didInsertElement: ->
    input = @$().find('input[type="file"]')
    @set 'input', input

    input.fileupload
      maxNumberOfFiles: 1
      add: (e, data) =>
        return if @get('modal.page.isNew') or @get('modal.theme.isNew')
        asset = @get 'asset'
        file  = data.files[0]

        asset.setProperties
          file: file
          mimeType: file.type
          fileSize: file.size
          name: file.name.replace(/\.[^\.]*?$/, '').underscore()

        @processImage file if asset.get('isImage')

        @get('modal').show()

  processImage: (file) ->
    @readAsDataURL(file).then (url) =>
      @set 'dataURL', url

      img = document.createElement 'img'
      img.onload = => @setProperties imageWidth: img.width, imageHeight: img.height
      img.src = url

  readAsDataURL: (file) ->
    new Ember.RSVP.Promise (resolve, reject) ->
      reader = new FileReader()
      reader.onloadend = (event) ->
        resolve event.currentTarget.result
      reader.readAsDataURL(file)
