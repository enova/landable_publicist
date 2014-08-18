# ex: {{pluralize widgets.length s="widget" p="widgets"}}
Ember.Handlebars.helper 'pluralize', (count, options) ->
  singular = options?.hash.s
  plural   = options?.hash.p || "#{singular}s"
  if count is 1 then "#{count} #{singular}" else "#{count} #{plural}"

Ember.Handlebars.helper 'capitalize', (s) ->
  s.charAt(0).toUpperCase() + s.slice(1) 

Ember.Handlebars.helper 'humanizeFileSize', (size) ->
  humanize.filesize size

Ember.Handlebars.helper 'relativeTime', (time) ->
  if ts = moment(time)
    str = Handlebars.Utils.escapeExpression ts.fromNow()
    new Handlebars.SafeString("<time datetime='#{ts.toISOString()}' data-moment-display='fromNow'>#{str}</time>")
