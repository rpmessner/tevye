context     = switch_view = null
teardownAll = -> clearAll()
isBlank     = Tevye.isBlank
module "SwitchView",
  setup: ->
    Ember.run ->
      context = Em.Object.create
        label: "boolValue"
        boolValue: false
      switch_view = Tevye.SwitchView.create
        valueBinding: "content.boolValue"
        labelBinding: "content.label"
        content: context
      switch_view.appendTo('#ember-testing')
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: teardownAll.andThen ->
    Ember.run ->
      switch_view.remove()
      switch_view.destroy()
      switch_view = null

test "creating", ->
  ok !isBlank(switch_view)

asyncTest "should reset value when switched", ->
  expect 4
  waitForRender ->
    click switch_view.$("label")
    ok context.get("boolValue")
    ok switch_view.get("value")

    click switch_view.$("label")
    ok !context.get("boolValue")
    ok !switch_view.get("value")

    start()
