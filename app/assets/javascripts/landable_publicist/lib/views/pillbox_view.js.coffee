Publicist.PillboxView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['nav', 'nav-pills'] # lol?

  didInsertElement: ->
    tooltips = @$().find('[data-toggle="tooltip"]')
    tooltips.tooltip delay: { show: 300, hide: 200 }, placement: 'bottom'

  itemViewClass: Ember.View.extend
    template: Ember.Handlebars.compile """
      <a href='#' {{bindAttr title=view.content}} data-toggle='tooltip'>
        {{view.content}}
      </a>
      """

    classNameBindings: ['active']

    directivesBinding: 'parentView.directives'

    active: (->
      @get('directives')?.contains @get('content')
    ).property('directives.[]')

    click: (event) ->
      event.preventDefault()
      @toggle()

    toggle: ->
      name       = @get('content')
      directives = @get('directives')

      # make a brand new set of directives, thus creating a new reference, and
      # forcing Ember Data to take notice and dirty the record in question
      if @get('active')
        newDirectives = directives.without(name)
      else
        newDirectives = directives.slice()
        newDirectives.push name

      @set 'directives', newDirectives
