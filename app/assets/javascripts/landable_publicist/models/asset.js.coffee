Publicist.Asset = DS.Model.extend
  author: DS.belongsTo('author')
  themes: DS.hasMany('theme', async: true)
  pages:  DS.hasMany('page', async: true)

  name: DS.attr()
  description: DS.attr('string', defaultValue: '')
  fileSize: DS.attr('number')
  mimeType: DS.attr()
  md5sum: DS.attr('string', readOnly: true)

  publicUrl: DS.attr('string', readOnly: true)

  # make a guess at the complete url, if we're missing a host
  previewUrl: (->
    if @get('publicUrl').match(/^(https?:)?\/\/([\w-]+)\.(\w+)/)
      @get('publicUrl')
  ).property('publicUrl')

  file: DS.attr('file')

  createdAt: DS.attr('date', readOnly: true)
  updatedAt: DS.attr('date', readOnly: true)

  isImage:    (-> Publicist.Asset.IMAGE_TYPES.contains(@get('mimeType'))).property('mimeType')
  isDocument: (-> Publicist.Asset.DOCUMENT_TYPES.contains(@get('mimeType'))).property('mimeType')
  isOther:    (-> !@get('isImage') && !@get('isDocument')).property('isImage', 'isDocument')

  iconName: (->
    if @get('isImage') then 'fa fa-camera'
    else if @get('isDocument') then 'fa fa-print'
    else 'fa fa-file'
  ).property('mimeType')

  previewContent: (->
    if @get('isImage')
      "<img src='#{@get('publicUrl')}' />"
    else
      @get('description')
  ).property()

# https://en.wikipedia.org/wiki/Internet_media_type#Type_image
Publicist.Asset.IMAGE_TYPES = [
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/svg+xml'
]

# TODO determine the mime types for .doc, .docx, .xls, .xlsx, etc etc
Publicist.Asset.DOCUMENT_TYPES = [
  'application/pdf'
]


Publicist.Asset.SORTS = [
  { value: 'createdAt',     label: 'Created'      },
  { value: 'fileSize',      label: 'File Size'    },
  { value: 'pages.length',  label: '# of Pages'   },
  { value: 'themes.length', label: '# of Themes'  },
]
