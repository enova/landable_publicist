Publicist.Audit = DS.Model.extend
  auditableId:   DS.attr()
  auditableType: DS.attr()
  notes:         DS.attr()
  flags:         DS.attr('raw', defaultValue: [])
  approver:      DS.attr()
  createdAt:     DS.attr('date')

  auditable: (->
    if @get('isPage')
      @store.find('page', @get('auditableId'))
    else
      @store.find('template', @get('auditableId'))
  ).property('isPage')

  isPage:        (-> @get('auditableType') == 'page').property('auditableType')
  isTemplate:    (-> @get('auditableType') == 'template').property('auditableType')

  createdAtReadableShort: (-> moment(@get 'createdAt').format('MMM DD YYYY,  h:mm a')).property('createdAt')

Publicist.TemplateAudit = Publicist.Audit.extend
  template:   DS.belongsTo('template')

Publicist.PageAudit = Publicist.Audit.extend
  page:       DS.belongsTo('page')
