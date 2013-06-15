# describe "Rev.PagesListView", ->
#   pagesListView = indexLink = pagesController = null
#   async = new AsyncSpec(this)
#   getPagesListView = (router) ->
#     getChildViewByName getViewByName("theme"), /PagesListView/

#   beforeEach ->
#     runs ->
#       setupAjax()
#       window.location.hash = "#/themes/#{themeId}"
#     respond TestResponses.themes.findAllSuccess
#     respond TestResponses.pages.findAllSuccess

#   afterEach ->
#     pagesListView = pagesController = null
#     window.location.hash = ""
#     clearAll()

#   async.it "should render the page list view on the theme page", (done) ->
#     waitForRender ->
#       pagesListView = getPagesListView()
#       expect(pagesListView).toBeDefined()
#       done()

#   async.it "should recieve the pages controller for the current theme", (done) ->
#     waitForRender ->
#       pagesListView = getPagesListView()
#       pagesController = lookup("controller:pages")
#       expect(pagesController).toBeDefined()
#       expect(pagesController.get("content.firstObject.themeId")).toEqual themeId
#       expect(pagesListView.get("controller")).toBe pagesController
#       done()

#   async.it "should render proper tags & classes for each element", (done) ->
#     waitForRender ->
#       pagesListView = getPagesListView()
#       expect(pagesListView.$("ul.side-nav").length).toEqual 1
#       expect(pagesListView.$("ul.page-node").length).toEqual 6
#       expect(pagesListView.$("li.root").length).toEqual 2
#       expect(pagesListView.$("li.child").length).toEqual 4
#       done()

#   async.it "open and close node", (done) ->
#     waitForRender ->
#       pagesListView = getPagesListView()
#       expect(visiblePages(pagesListView).length).toEqual 2
#       expect(allIcons(pagesListView).length).toEqual 2
#       expect(visibleIcons(pagesListView).length).toEqual 1
#       expect(hiddenIcons(pagesListView).length).toEqual 1
#       expect(openIcons(pagesListView).length).toEqual 2
#       expect(closeIcons(pagesListView).length).toEqual 0
#       click allIcons(pagesListView).first()
#       expect(visiblePages(pagesListView).length).toEqual 5
#       expect(visibleIcons(pagesListView).length).toEqual 2
#       expect(hiddenIcons(pagesListView).length).toEqual 0
#       expect(openIcons(pagesListView).length).toEqual 1
#       expect(closeIcons(pagesListView).length).toEqual 1
#       click allIcons(pagesListView).last()
#       expect(visiblePages(pagesListView).length).toEqual 6
#       expect(visibleIcons(pagesListView).length).toEqual 2
#       expect(hiddenIcons(pagesListView).length).toEqual 0
#       expect(openIcons(pagesListView).length).toEqual 0
#       expect(closeIcons(pagesListView).length).toEqual 2
#       done()

#   async.it "selecting", (done) ->
#     waitForRender ->
#       pagesListView = getPagesListView()
#       indexLink = pagesListView.$("a:nth(0)")
#       expect(pagesListView.$(".active").length).toEqual 0
#       expect(pagesListView.$("a").length).toEqual 6
#       expect(indexLink.attr("href")).toMatch "themes/#{themeId}/pages/#{indexId}"
#       click indexLink
#       waitForRender ->
#         expect(lookup("controller:page").get("content.id")).toEqual indexId
#         expect(document.location.hash).toMatch "themes/#{themeId}/pages/#{indexId}"
#         expect(pagesListView.$(".active").length).toEqual 1
#         done()

#   async.it "create button", (done) ->
#     button = undefined
#     textField = undefined
#     clearAjaxRequests()
#     waitForRender ->
#       pagesListView = getPagesListView()
#       button = allNewButtons(pagesListView)[0]
#       textField = allTextInputs(pagesListView)[0]
#       expect(textField).toBeUndefined()
#       expect(button).toBeDefined()
#       controller = lookup("controller:pages")
#       spyOn controller, "create"
#       click button
#       textField = allTextInputs(pagesListView).first()
#       expect(textField).toBeDefined()
#       typeText("New Page").into(textField).andHitEnter()
#       expect(controller.create).toHaveBeenCalled()
#       done()
