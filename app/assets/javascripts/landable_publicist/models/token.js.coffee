Publicist.Token = DS.Model.extend
  author:           DS.belongsTo('author')
  header:           DS.attr()
  expiresAt:        DS.attr()
