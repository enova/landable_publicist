Publicist.AssetPanelView = Ember.View.extend
  templateName: 'assets/panel_view'
  tagName: 'div'
  classNames: ['asset-panel']
  isExpanded: false

  showPanel: (->
    if @get('isExpanded')
      @$().addClass('expanded').attr(tabindex: 1)
      @$('input[type=search]').focus()
    else
      @$().removeClass('expanded').attr(tabindex: null)
  ).observes('isExpanded')

  didInsertElement: ->
    $(document).on 'click.assetPanel', 'a[data-toggle="panel"]', =>
      @toggle()
      
    $(document).on 'keydown.assetPanel', 'input[data-toggle="panel"]', (e) =>
      if e.keyCode == 13
        e.preventDefault()
        e.stopPropagation()

        @set('controller.searchTerm', $(e.target).val())
        @toggle()

        $(e.target).val('')

    @$().on 'click.assetPanel', 'a[data-insert-tag]', (e) =>
      anchor  = $(e.target)
      tagType = anchor.data('insert-tag')
      nameTag = anchor.parents('[data-asset-name]')
      @insertLiquid tagType, nameTag.data('asset-name'), nameTag.data('asset-name-prefix')
      @hide()

    @set 'backdrop', $('<div class="asset-panel-backdrop fade"></div>').hide().appendTo('body');
    $(document).on 'click.assetPanel', '.asset-panel-backdrop', =>
      @hide()

  willDestroyElement: ->
    $(document).off '.assetPanel'
    @get('backdrop').remove()

  toggle: -> @toggleProperty 'isExpanded'
  show:   -> @set 'isExpanded', true
  hide:   -> @set 'isExpanded', false

  keyDown: (evt) ->
    @hide() if evt.keyCode is 27 # aka escape

  insertLiquid: (tag, assetName, assetPrefix = '') ->
    editor = ace.edit $('.ace_editor')[0]
    editor.insert "{% #{tag} #{assetPrefix}#{assetName} %}"
    editor.focus()

  toggleBackdrop: (->
    if @get('isExpanded')
      @get('backdrop').show().addClass('in')
    else
      @get('backdrop').removeClass('in')
      setTimeout (=> @get('backdrop').hide()), 200
  ).observes('isExpanded')
