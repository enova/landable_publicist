Publicist.Template = DS.Model.extend
  body:              DS.attr()
  description:       DS.attr()
  deletedAt:         DS.attr('string')
  editable:          DS.attr('boolean', defaultValue: true)
  file:              DS.attr()
  isLayout:          DS.attr('boolean')
  isPublishable:     DS.attr('boolean', readOnly: true)
  name:              DS.attr()
  slug:              DS.attr()
  thumbnailUrl:      DS.attr()
  auditFlags:        DS.attr('raw', defaultValue: [])

  audits:            DS.hasMany('audit', async: true, readOnly: true)
  revisions:         DS.hasMany('templateRevision', async: true, readOnly: true)
  publishedRevision: DS.belongsTo('templateRevision', readOnly: true)
  revisions:         DS.hasMany('templateRevision', async: true, readOnly: true)

  isDeactivated:     (-> !!@get('deletedAt')).property('deletedAt')
  isPublished:       (-> !!@get('publishedRevision')).property('publishedRevision')