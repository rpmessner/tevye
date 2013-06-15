# describe "Rev.ResizableView", ->
#   resizableView = undefined
#   resizableViewClass = undefined
#   async = new AsyncSpec(this)
#   beforeEach ->
#     resizableViewClass = Rev.ResizableView.extend(
#       childViews: ["leftView", "rightView"]
#       leftView: Ember.View.create(
#         classNames: ["paneView"]
#         template: Ember.Handlebars.compile("<h1 class='first'>First Pane</h1>")
#       )
#       rightView: Ember.View.create(
#         classNames: ["paneView2"]
#         template: Ember.Handlebars.compile("<h1 class='second'>Second Pane</h1>")
#       )
#     )
#     resizableView = resizableViewClass.create()
#     Ember.run ->
#       resizableView.append()


#   afterEach ->
#     resizableView.destroy()
#     resizableView = null

#   async.it "renders", (done) ->
#     waitForRender ->
#       expect(resizableView.$("div.handle").length).toEqual 1
#       expect(resizableView.$("div.pane-container").length).toEqual 1
#       expect(resizableView.$("div.pane").length).toEqual 2
#       expect(resizableView.$("div.pane").hasClass("half")).toBeTruthy()
#       expect(resizableView.$("h1.first").length).toEqual 1
#       expect(resizableView.$("h1.second").length).toEqual 1
#       done()


#   async.it "defaults to horizontal", (done) ->
#     waitForRender ->
#       expect(resizableView.$().hasClass("horizontal")).toBeTruthy()
#       expect(resizableView.$().hasClass("vertical")).toBeFalsy()
#       done()


#   async.it "can be set to vertical", (done) ->
#     Ember.run ->
#       resizableView.set "orientation", "vertical"

#     waitForRender ->
#       expect(resizableView.$().hasClass("horitzontal")).toBeFalsy()
#       expect(resizableView.$().hasClass("vertical")).toBeTruthy()
#       done()


#   async.it "horizontal can be set to resize from the left", (done) ->
#     waitForRender ->
#       expect(resizableView.$(".handle").css("left")).toEqual "0px"
#       expect(resizableView.$(".handle").css("right")).toEqual "auto"
#       done()


#   async.it "horizontal can be set to resize from the right", (done) ->
#     width = undefined
#     Ember.run ->
#       resizableView.set "direction", "right"

#     waitForRender ->
#       expect(resizableView.$(".handle").css("left")).toEqual "auto"
#       expect(resizableView.$(".handle").css("right")).toEqual "0px"
#       done()


#   async.it "vertical can be set to resize from the bottom", (done) ->
#     Ember.run ->
#       resizableView.set "orientation", "vertical"

#     waitForRender ->
#       expect(resizableView.$(".handle").css("bottom")).toEqual "0px"
#       expect(resizableView.$(".handle").css("top")).toEqual "auto"
#       done()


#   async.it "vertical can be set to resize from the top", (done) ->
#     Ember.run ->
#       resizableView.set "orientation", "vertical"
#       resizableView.set "direction", "top"

#     waitForRender ->
#       width = resizableView.$().width()
#       expect(resizableView.$(".handle").css("bottom")).toEqual "auto"
#       expect(resizableView.$(".handle").css("top")).toEqual "0px"
#       done()
