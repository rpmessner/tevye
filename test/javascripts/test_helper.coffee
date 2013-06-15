# #= require application.js.coffee
# #= require_tree ./helpers
# #= require_self
# #= require_tree ./models
# #= require_tree ./controllers
# #= require_tree ./views
# #= require_tree ./routes

# App.set("rootElement", "#qunit-fixture")

# window.lookupStore = ->
#   App.__container__.lookup('store:main')

# window.lookupController = (name) ->
#   App.__container__.lookup('controller:' + name)

# window.lookupRouter = ->
#   App.__container__.lookup('router:main')

# stubSignIn = ->
#   AuthClient.Storage.setItem("session-token", AuthClient.stubToken)

# stubIndexRoute = ->
#   App.IndexRoute.reopen
#     redirect: ->

# redirectToIndex = ->
#   window.location.hash = "/"

# Ember.run ->
#   App.deferReadiness()

# QUnit.begin ->
#   Ember.run ->
#     App.reset()

# $( ->
#   stubIndexRoute()
#   redirectToIndex()
#   Ember.run ->
#     stubSignIn()
#     App.initialize()
#     App.startRouting()
# )
