Publicist.TemplateSelectionView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['template-selection thumbnails']

  itemViewClass: Ember.View.extend
    tagName: 'li'
    classNames: ['thumbnail']

    tooltip: (->
      '<strong>' + @get('content.name') + '</strong><br>' + @get('content.description')
    ).property('content.name', 'content.description')

    template: Ember.Handlebars.compile """
      <img {{bindAttr src=view.thumbnail}} data-toggle="tooltip" data-html="true" data-placement="left" {{bindAttr title=view.tooltip}} />
    """

    thumbnail: (-> @get('content.thumbnailUrl') or 'http://placehold.it/200x150').property('content.thumbnailUrl')

    click: (event) ->
      @set 'controller.model.body', @get('content.body')
