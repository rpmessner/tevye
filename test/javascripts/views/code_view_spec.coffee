# describe "Rev.CodeView", ->
#   async = new AsyncSpec(this)
#   index = asset = assets = pages = themes = codeView =
#     page = stylesheet = codeView = assetsController = null

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#       assets = Rev.ThemeAsset.findAll(theme_id: themeId)
#       pages = Rev.Page.findAll(theme_id: themeId)
#       themes = Rev.Theme.findAll()
#     waits 10

#   afterEach ->
#     codeView.destroy()
#     codeView = null
#     expect($(".CodeMirror").length).toEqual 0
#     clearAll()

#   describe "with a theme asset", ->
#     beforeEach ->
#       runs ->
#         page = Rev.Page.find(indexId, theme_id: themeId)
#         stylesheet = Rev.ThemeAsset.find(stylesheetId, theme_id: themeId)
#         assetsController = Rev.ThemeAssetsController.create(content: assets)
#         spyOn(assetsController, 'create')
#         spyOn(assetsController, 'destroy')
#         codeView = Rev.CodeView.create
#           assetsBinding: "controller.stylesheets"
#           selectedAssetBinding: "controller.selectedStylesheet"
#           valueBinding: "controller.selectedStylesheet.originalSource"
#           modeBinding: "controller.selectedStylesheet.mode"
#           assetsController: assetsController
#           controller: Rev.ItemController.create
#             selectedStylesheet: stylesheet
#             stylesheets: page.get("stylesheets")
#             content: page
#       waits 10

#     async.it "renders", (done) ->
#       Ember.run ->
#         codeView.append()

#       waitForRender ->
#         id = codeView.$().attr("id")
#         expect($("#" + id).length).toEqual(1)
#         done()

#     async.it "renders a codemirror with the asset source", (done) ->
#       Ember.run ->
#         codeView.append()
#       waitForRender ->
#         mirror = codeView.get("mirror")
#         expect(mirror).not.toBeEmpty()
#         expect(codeView.get("value")).toEqual(stylesheet.get("originalSource"))
#         expect(mirror.doc.getValue()).toEqual(stylesheet.get("originalSource"))
#         done()

#     async.it "updates the asset on save", (done) ->
#       Ember.run ->
#         codeView.append()
#       waitForRender ->
#         mirror = codeView.get("mirror")
#         evt =
#           type: "keydown"
#           keyCode: 83 # S
#           metaKey: true

#         mirror.doc.setValue "h1 { color: blue; }"
#         mirror.triggerOnKeyDown evt
#         waitForSync ->
#           expect(stylesheet.get("originalSource")).toEqual(mirror.doc.getValue())
#           done()

#     async.it 'removes the asset on destroy', (done) ->
#       Em.run ->
#         codeView.append()
#       waitForRender ->
#         click(codeView.$('button.destroy'))
#         expect(assetsController.destroy).toHaveBeenCalledWith(stylesheetId)
#         done()

#     async.it 'creates new asset', (done) ->
#       Em.run ->
#         codeView.append()
#       waitForRender ->
#         filename = 'page-asset.js'

#         click(codeView.$('button.new'))
#         typeText(filename).into(codeView.$('input')).andHitEnter()

#         expect(assetsController.create).toHaveBeenCalledWith(name: filename)
#         done()

#     async.it "is allowed to be created with a null asset", (done) ->
#       Ember.run ->
#         codeView.set("controller", Ember.Object.create())
#         codeView.append()

#       waitForRender ->
#         expect(codeView.get("value")).toBeUndefined()
#         done()

#     async.it "changing the view controller updates the mirror", (done) ->
#       Ember.run ->
#         codeView.set("controller.selectedStylesheet", null)
#         codeView.append()

#       waitForRender ->
#         expect(codeView.get("value")).toBeNull()
#         codeView.set("controller.selectedStylesheet", stylesheet)
#         waitForSync ->
#           expect(codeView.get("value")).toEqual(stylesheet.get("originalSource"))
#           mirror = codeView.get("mirror")
#           expect(mirror.doc.getValue()).toEqual(stylesheet.get("originalSource"))
#           expect(mirror.doc.mode.name).toEqual(stylesheet.get("mode"))
#           done()

#     async.it "modifying the view controller updates the mirror", (done) ->
#       Ember.run ->
#         asset = Ember.Object.create()
#         codeView.set("controller.selectedStylesheet", asset)
#         codeView.append()

#       waitForRender ->
#         expect(codeView.get("value")).toBeUndefined()
#         asset.set("mode", stylesheet.get("mode"))
#         asset.set("originalSource", stylesheet.get("originalSource"))
#         waitForSync ->
#           expect(codeView.get("value")).toEqual(stylesheet.get("originalSource"))
#           mirror = codeView.get("mirror")
#           expect(mirror.doc.getValue()).toEqual(stylesheet.get("originalSource"))
#           expect(mirror.doc.mode.name).toEqual(stylesheet.get("mode"))
#           done()

#   describe "with a page template", ->
#     beforeEach ->
#       runs ->
#         index = Rev.Page.find(indexId, theme_id: themeId)
#         codeView = Rev.CodeView.create
#           valueBinding: "controller.rawTemplate"
#           modeBinding: "controller.mode"
#           controller: index
#       waits 10

#     async.it "displays a page template in the mirror", (done) ->
#       Ember.run ->
#         codeView.append()

#       waitForRender ->
#         mirror = codeView.get("mirror")
#         expect(mirror).not.toBeEmpty()
#         expect(codeView.get("value")).toEqual(index.get("rawTemplate"))
#         expect(mirror.doc.getValue()).toEqual(index.get("rawTemplate"))
#         done()
