Publicist.PageRevision =  DS.Model.extend
  author: DS.belongsTo('author')
  page:   DS.belongsTo('page')

  ordinal:      DS.attr('number')
  notes:        DS.attr('string')
  isMinor:      DS.attr('boolean')
  isPublished:  DS.attr('boolean')
  previewPath:  DS.attr('string', readOnly: true)
  # previewUrl:   Update so doesn't use old site environment 

  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')
  createdAtFromNow: (-> moment(@get 'createdAt').fromNow()).property('createdAt')

  createdAtReadableShort: (-> moment(@get 'createdAt').format('MMM DD YYYY')).property('createdAt')
  updatedAtReadableShort: (-> moment(@get 'updatedAt').format('MMM DD YYYY')).property('updatedAt')
  createdAtReadableTime: (-> moment(@get 'createdAt').format('h:mm:ss a')).property('createdAt')
  updatedAtReadableTime: (-> moment(@get 'updatedAt').format('h:mm:ss a')).property('updatedAt')
