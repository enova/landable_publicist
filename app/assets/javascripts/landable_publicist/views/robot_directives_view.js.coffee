Publicist.RobotDirectivesView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['nav', 'nav-pills'] # lol?
  contentBinding: Ember.Binding.oneWay('Publicist.MetaTags.robotDirectives')
  pageBinding: 'controller.model'

  didInsertElement: ->
    tooltips = @$().find('[data-toggle="tooltip"]')
    tooltips.tooltip delay: { show: 300, hide: 200 }, placement: 'bottom'

  itemViewClass: Ember.View.extend
    template: Ember.Handlebars.compile """
      <a href='#' {{bindAttr title=view.content.description}} data-toggle='tooltip'>
        {{view.content.name}}
      </a>
      """

    classNameBindings: ['active']
    directivesBinding: 'controller.model.metaTagsProxy.robotsProxy'

    active: (->
      @get('directives')?.contains @get('content.name')
    ).property('directives.[]')

    click: (event) ->
      event.preventDefault()
      @toggle()

    toggle: ->
      name       = @get('content.name')
      directives = @get('directives')
      if @get('active')
        directives.remove name
      else
        directives.add name
