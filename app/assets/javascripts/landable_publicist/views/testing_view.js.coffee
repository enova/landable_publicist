Publicist.TestingView = Ember.View.extend

  templateName: 'testing'

  didInsertElement: ->
    @$('.browsers-secondary + .toggle').click ->
      $(this).prev('.browsers-secondary').toggleClass('show')

    @$('.modal').on 'show', => @set('controller.autoUpdate', true)
    @$('.modal').on 'hide', => @set('controller.autoUpdate', false)

  willDestroyElement: ->
    @set('controller.autoUpdate', false)

Publicist.PageTestingView = Publicist.TestingView.extend()
Publicist.PageRevisionTestingView = Publicist.TestingView.extend()