Publicist.ListView = Ember.ListView.extend
  css: {
    'position': 'relative'
    'overflow-y': 'scroll'
    '-webkit-overflow-scrolling': 'touch'
    'overflow-scrolling': 'touch'
  }

  height: 400
  rowHeight: 25

  classNames: ['publicist-list-view']

  emptyViewClass: Ember.ListItemView.extend
    classNames: ['publicist-list-empty-view']

  init: ->
    @_super()

    # TODO finish support for the collection helper's inverse
    if @get('emptyViewClass') and not @get('emptyView')
      @set 'emptyView', @get('emptyViewClass')

    # if we were provided an emptyView template for this instance, apply it
    if @get 'emptyTemplate'
      emptyView = @get('emptyView')

      @set 'emptyView', emptyView.extend
        template: Ember.Handlebars.compile(@get 'emptyTemplate')

  # overriding to support emptyView
  arrayDidChange: (content, start, removed, added) ->
    length = content?.get 'length'

    # if the array is empty, insert the empty view
    if not length
      unless @get('isDestroyed')
        emptyView = @createChildView @get('emptyView')
        @set '_emptyView', emptyView
        @addObject emptyView

    # otherwise,
    else
      unless @get('isDestroyed')
        # remove the empty view, if one exists
        if @get('_emptyView')
          @removeObject @get('_emptyView')
          @set '_emptyView', null

      # and pass the call up
      @_super content, start, removed, added

  didInsertElement: ->
    # ensure listing panes are the right size
    $(window).on 'resize.publicist.listview', => @resize()
    @resize()

    @_super()

  willDestroyElement: ->
    # leaving; deactivate the resize handler
    $(window).off 'resize.publicist.listview'

    @_super()

  resize: ->
    offsetTop = @$().offset()?.top
    newHeight = $(window).height() - offsetTop - 50

    if newHeight
      @set 'height', newHeight
