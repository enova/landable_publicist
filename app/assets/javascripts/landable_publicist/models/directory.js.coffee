Publicist.Directory = DS.Model.extend

  path: DS.attr()
  pages: DS.hasMany('page', async: true)
  subdirectories: DS.hasMany('directory', async: true)

  name: (-> @get('path')?.split('/').pop()).property('path')

  # yes, this includes the current directory. if you have a better name for
  # this, throw it in.
  parents: (->
    parents = ['/']
    pathSegments = ['']

    for segment in (@get('path')?.split('/') || []) when segment
      pathSegments.push segment
      parents.push pathSegments.join('/')

    @store.find 'directory', ids: parents
  ).property()
