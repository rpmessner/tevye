#= require_tree ./tevye/external
#= require ./tevye/store
#= require_self
#= require ./tevye/config
#= require_tree ./tevye/models
#= require_tree ./tevye/controllers
#= require_tree ./tevye/views
#= require_tree ./tevye/helpers
#= require_tree ./tevye/templates
#= require_tree ./tevye/routes
#= require ./tevye/router
window.Tevye = Ember.Application.create
  LOG_TRANSITIONS: true
