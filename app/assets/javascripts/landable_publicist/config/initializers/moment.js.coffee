# autoupdate time elements
Ember.Application.initializer
  name: 'moment'

  initialize: (container, app) ->
    $rootElement = $(app.get 'rootElement')

    updateMoment = ->
      $rootElement.find('time[data-moment-display]').each ->
        $time = $(@)
        ts = moment($(@).attr('datetime'))

        switch $time.data('moment-display')
          when 'fromNow' then $time.text(ts.fromNow())
          # the following may be useful at some point.
          # when 'format'
          #   format = $time.data('moment-format')
          #   $(@).text(ts.format(format))

    setInterval updateMoment, 1000
