# describe "Rev.ContentTypesListView", ->
#   types = controller = listView = null

#   async = new AsyncSpec(this)

#   getContentTypesListView = (router) ->
#     getChildViewByName getRouter()._lookupActiveView("theme"), /ContentTypesListView/

#   beforeEach ->
#     runs ->
#       setupPreload()
#       setupAjax()
#       window.location.hash = "#/themes/#{themeId}"

#   afterEach ->
#     types = listView = controller = null
#     window.location.hash = ""
#     clearAll()

#   async.it "should be created", (done) ->
#     waitForRender ->
#       listView = getContentTypesListView()
#       expect(listView).toBeDefined()
#       done()

#   async.it "should recieve the content types controller for the current theme", (done) ->
#     waitForRender ->
#       listView = getContentTypesListView()
#       controller = lookup("controller:contentTypes")
#       expect(controller).toBeDefined()
#       expect(controller.get("content.firstObject.themeId")).toEqual themeId
#       expect(listView.get("controller")).toBe controller
#       done()

#   async.it "should render proper tags & classes for each element", (done) ->
#     waitForRender ->
#       listView = getContentTypesListView()
#       expect(listView.$("ul.side-nav").length).toEqual 1
#       expect(listView.$("ul").length).toEqual 1
#       expect(listView.$("li").length).toEqual 2
#       done()

#   async.it "editing", (done) ->
#     waitForRender ->
#       listView = getContentTypesListView()
#       expect(listView.$(".active").length).toEqual 0
#       expect(allContentTypeLinks(listView).length).toEqual 2
#       expect(allContentTypeLinks(listView).first().attr("href")).toMatch "themes/#{themeId}/content_types/#{recipesId}"
#       click editIcons(listView).first()
#       waitForRender ->
#         expect(lookup("controller:contentType").get("content.id")).toEqual recipesId
#         expect(listView.$(".active").length).toEqual 1
#         done()

#   async.it "selecting", (done) ->
#     waitForRender ->
#       listView = getContentTypesListView()
#       expect(listView.$(".selected").length).toEqual 0
#       expect(listView.$(".select").length).toEqual 2
#       click listView.$(".select").first()
#       waitForRender ->
#         expect(lookup("controller:contentTypes").get("selected.id")).toEqual recipesId
#         expect(listView.$(".selected").length).toEqual 1
#         done()
