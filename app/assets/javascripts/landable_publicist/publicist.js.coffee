## dependencies
#= require ace/application
#= require uuid
#= require jquery
#= require jquery.iframe-auto-height
#= require jquery.pnotify
#= require jquery.cookie
#= require qrcode
#= require humanize
#= require moment
#= require handlebars
#= require ember/development/ember
#= require ember/development/ember-data
#= require ember-list-view
#= require core-admin/application

## application
#= require_self
#= require_tree ./lib
#= require_tree ./config
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./routes
#= require_tree ./templates

# don't print the ember version on init
Ember.LOG_VERSION = false

# construct the app
window.Publicist = Ember.Application.create()
