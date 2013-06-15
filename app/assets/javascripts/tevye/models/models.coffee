attr = Ember.attr

Tevye.Model = Ember.Model.extend()

Tevye.Model.reopenClass
  adapter: Em.RESTAdapter.create()

Tevye.User = Tevye.Model.extend
  id: attr()
  name: attr()

Tevye.User.reopenClass
  url: "/api/users/"
