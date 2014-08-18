Publicist.PagesSearchView = Ember.View.extend

  didInsertElement: ->
    @$(':input.search-path').focus().on 'keydown', (e) ->
      # escape
      $(this).blur() if e.keyCode is 27

  selectedResult: null

  keyDown: (e) ->
    results = @$('.pages .page')
    selectedResult = $(@get('selectedResult')) if @get('selectedResult')

    switch e.keyCode
      when 38 # up
        if selectedResult
          selectedResult = selectedResult.parent().prev().find('.page')
        else
          selectedResult = results.last()
      when 40 # down
        if selectedResult
          selectedResult = selectedResult.parent().next().find('.page')
        else
          selectedResult = results.first()
      when 13 # enter
        selectedResult?.click()

    $('.pages .page.hover').removeClass('hover')

    if selectedResult
      @set 'selectedResult', selectedResult[0]
      selectedResult?.addClass('hover')
