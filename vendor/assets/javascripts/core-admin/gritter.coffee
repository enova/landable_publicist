class @Growl

  @info = (options) ->
    options['class_name'] = "info"
    options.title = "<i class='icon-info-sign'></i> #{options.title}"
    $.gritter.add options

  @warn = (options) ->
    options['class_name'] = "warn"
    options.title = "<i class='icon-warning-sign'></i> #{options.title}"
    $.gritter.add options

  @error = (options) ->
    options['class_name'] = "error"
    options.title = "<i class='icon-exclamation-sign'></i> #{options.title}"
    $.gritter.add options

  @success = (options) ->
    options['class_name'] = "success"
    options.title = "<i class='icon-ok-sign'></i> #{options.title}"
    $.gritter.add options

$ ->

  $.extend($.gritter.options, position: 'top-right')

  # this part here (below) is for demo purposes only

  $(".growl-info").click (e) ->
    e.preventDefault()
    Growl.info
      title: 'This is a notice!',
      text: 'This will fade out after a certain amount of time.'

  $(".growl-warn").click (e) ->
    e.preventDefault()
    Growl.warn
      title: 'This is a warning!',
      text: 'This will fade out after a certain amount of time.'

  $(".growl-error").click (e) ->
    e.preventDefault()
    Growl.error
      title: 'This is an error!',
      text: 'This will fade out after a certain amount of time.'

  $(".growl-success").click (e) ->
    e.preventDefault()
    Growl.success
      title: 'This is a success message!',
      text: 'This will fade out after a certain amount of time.'