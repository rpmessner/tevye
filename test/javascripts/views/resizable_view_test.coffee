resizable_view = null
module "ResizableView",
  setup: ->
    view_class = Tevye.ResizableView.extend
      childViews: ["leftView", "rightView"]
      leftView: Ember.View.create
        classNames: ["pane-view"]
        template: Ember.Handlebars.compile("<h1 class='first'>First Pane</h1>")

      rightView: Ember.View.create
        classNames: ["pane-view-2"]
        template: Ember.Handlebars.compile("<h1 class='second'>Second Pane</h1>")

    resizable_view = view_class.create()
    Ember.run -> resizable_view.appendTo('#ember-testing')

  teardown: clearAll.andThen ->
    resizable_view.destroy()
    resizable_view = null

asyncTest "renders", ->
  waitForRender ->
    equal resizable_view.$("div.handle").length, 1
    equal resizable_view.$("div.pane-container").length, 1
    equal resizable_view.$("div.pane").length, 2
    ok resizable_view.$("div.pane").hasClass("half")
    equal resizable_view.$("h1.first").length, 1
    equal resizable_view.$("h1.second").length, 1
    start()

asyncTest "defaults to horizontal", ->
  waitForRender ->
    ok resizable_view.$().hasClass("horizontal")
    ok !resizable_view.$().hasClass("vertical")
    start()

asyncTest "can be set to vertical", ->
  Ember.run -> resizable_view.set "orientation", "vertical"
  waitForRender ->
    ok !resizable_view.$().hasClass("horitzontal")
    ok resizable_view.$().hasClass("vertical")
    start()

asyncTest "horizontal can be set to resize from the left", ->
  waitForRender ->
    equal resizable_view.$(".handle").css("left"), "0px"
    equal resizable_view.$(".handle").css("right"), "auto"
    start()

asyncTest "horizontal can be set to resize from the right", ->
  Ember.run -> resizable_view.set "direction", "right"

  waitForRender ->
    equal resizable_view.$(".handle").css("left"), "auto"
    equal resizable_view.$(".handle").css("right"), "0px"
    start()

asyncTest "vertical can be set to resize from the bottom", ->
  Ember.run -> resizable_view.set "orientation", "vertical"

  waitForRender ->
    equal resizable_view.$(".handle").css("bottom"), "0px"
    equal resizable_view.$(".handle").css("top"), "auto"
    start()

asyncTest "vertical can be set to resize from the top", ->
  Ember.run ->
    resizable_view.set "orientation", "vertical"
    resizable_view.set "direction", "top"

  waitForRender ->
    equal resizable_view.$(".handle").css("bottom"), "auto"
    equal resizable_view.$(".handle").css("top"), "0px"
    start()
