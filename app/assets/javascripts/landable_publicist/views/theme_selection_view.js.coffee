Publicist.ThemeSelectionView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['row-fluid theme-selection thumbnails']

  itemViewClass: Ember.View.extend
    classNames: ['span2']
    classNameBindings: ['isCurrent']

    template: Ember.Handlebars.compile """
      <div class="thumbnail">
        <div class="image">
          <img {{bindAttr src=view.thumbnail}} />
        </div>
        <label class="meta">
          <div class="name">{{view.content.name}}</div>
          <div class="description">{{view.content.description}}</div>
        </label>
      </div>
      """

    thumbnail: (->
      @get('content.thumbnailUrl')
    ).property('content')

    isCurrent: (->
      @get('content.id') is @get('controller.model.theme.id')
    ).property('controller.model.theme', 'controller.model.theme.id')

    click: (event) ->
      if @get('isCurrent')
        @set 'controller.model.theme', ''
      else
        @set 'controller.model.theme', @get('content')
