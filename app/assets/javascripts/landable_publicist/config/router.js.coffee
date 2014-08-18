Publicist.Router.map ->

  @resource 'index', path: '/'

  @resource 'audits'

  @resource 'directories', ->
    @route 'directory', path: '*directory_id'


  @resource 'pages', ->
    @route 'new'
    @route 'search'

    @resource 'page', path: ':page_id', ->
      @route 'code'
      @route 'preview'
      @route 'revisions'
      @route 'audits'


  @resource 'themes', ->
    @route 'new'

    @resource 'theme', path: ':theme_id', ->
      @route 'code'
      @route 'preview'


  @resource 'templates', ->
    @route 'new'

    @resource 'template', path: ':template_id', ->
      @route 'code'
      @route 'audits'
      @route 'revisions'


  @resource 'assets', ->
    @route 'new'

    @resource 'asset', path: ':asset_id'

  @route 'fourOhFour', path: '*path'
