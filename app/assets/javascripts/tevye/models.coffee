attr = Ember.attr

App.Model = Ember.Model.extend()

App.Model.reopenClass
  adapter: Em.RESTAdapter.create()

App.User = App.Model.extend
  id: attr()
  name: attr()

App.User.reopenClass
  url: "/api/users/"
