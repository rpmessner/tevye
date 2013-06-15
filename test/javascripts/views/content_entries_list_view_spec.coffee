# describe "Rev.ContentEntriesListView", ->
#   async = new AsyncSpec(this)

#   getContentTypesListView = (router) ->
#     getChildViewByName getRegisteredView('theme'), /ContentTypesListView/

#   getContentEntriesListView = (router) ->
#     getChildViewByName getRegisteredView("theme"), /ContentEntriesListView/

#   beforeEach ->
#     runs ->
#       setupPreload()
#       setupAjax()
#       window.location.hash = "#/themes/#{themeId}"

#   afterEach ->
#     window.location.hash = ""
#     clearAll()

#   async.it "should be created", (done) ->
#     waitForRender ->
#       listView = getContentEntriesListView()
#       expect(listView).toBeDefined()
#       done()

#   async.it "should recieve the content types controller for the current theme", (done) ->
#     waitForRender ->
#       controller = lookup('controller:contentEntries')
#       expect(controller).toBeDefined()
#       expect(controller.get("content")).not.toBeDefined()

#       typesListView = getContentTypesListView()
#       click typesListView.$(".select:first")
#       waitForRender ->
#         expect(controller.get("content.firstObject.themeId")).toEqual themeId

#         listView = getContentEntriesListView()
#         expect(listView.get("controller")).toBe controller
#         done()
