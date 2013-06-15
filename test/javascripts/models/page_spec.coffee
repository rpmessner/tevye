# describe "Rev.Page", ->
#   page = pages = request = null

#   async = new AsyncSpec(this)

#   beforeEach ->
#     setupAjax()

#   afterEach ->
#     pages = page = request = null
#     clearAll()

#   describe "findAll for theme from server", ->
#     beforeEach ->
#       pages = Rev.Page.findAll(pageOptions)
#       request = respondToAjax(TestResponses.pages.findAllSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "pages?theme_id=#{themeId}"
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(pages.get("length")).toEqual pageIds.length
#         expect(pages.get("content").first().get("id")).toEqual indexId
#         done()

#   describe "findAll from preload", ->
#     beforeEach ->
#       PreloadStore.store "pages?theme_id=#{themeId}", pagesJSON
#       pages = Rev.Page.findAll(pageOptions)
#       request = mostRecentAjaxRequest()
#       expect(request).toBeNull()

#     async.it "can be successfull", (done) ->
#       waitForSync ->
#         expect(pages.get("length")).toEqual pageIds.length
#         expect(pages.get("content").first().get("id")).toEqual indexId
#         done()

#   describe "find from server", ->
#     beforeEach ->
#       page = Rev.Page.find(indexId, pageOptions)
#       request = respondToAjax(TestResponses.pages.findSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "pages/#{indexId}?theme_id=#{themeId}"
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(page.get("id")).toEqual indexId
#         expect(page.get("themeId")).toEqual themeId
#         done()

#   describe "create with id & attributes", ->
#     attributes = pageJSON.page
#     it "is immediately successful", ->
#       page = Rev.Page.create(attributes)
#       expect(page.get("theme_id")).toBeUndefined()
#       expect(page.get("themeId")).toEqual themeId

#   describe "create without id", ->
#     attributes = title: "Index Page"
#     beforeEach ->
#       page = Rev.Page.create(attributes, pageOptions)
#       request = respondToAjax(TestResponses.pages.findSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.method).toBe "POST"
#       expect(request.url).toBe "pages?theme_id=#{themeId}"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(page.get("title")).toEqual "Index Page"
#         done()

#   describe "destroy", ->
#     beforeEach ->
#       page = Rev.Page.create(pageJSON.page)
#       spyOn(page, "destroy").andCallThrough()
#       page.destroyModel pageOptions
#       request = respondToAjax(TestResponses.pages.deleteSuccess)
#       expect(request.method).toBe "DELETE"
#       expect(request.url).toBe "pages/#{indexId}?theme_id=#{themeId}"

#     async.it "is successful", (done) ->
#       waitForSync ->
#         expect(page.destroy).toHaveBeenCalled()
#         expect(page.isDestroyed).toEqual true
#         done()

#   describe "update", ->
#     beforeEach ->
#       page = Rev.Page.create(pageJSON.page)
#       page.update(title: "Index Page Updated", pageOptions)
#       request = respondToAjax(TestResponses.pages.updateSuccess)
#       expect(request.method).toBe "PUT"
#       expect(request.url).toBe "pages/#{indexId}?theme_id=#{themeId}"

#     async.it "is successful", (done) ->
#       waitForSync ->
#         expect(page.get("title")).toEqual "Index Page Updated"
#         done()

#   describe "can retrieve theme", ->
#     beforeEach ->
#       page = Rev.Page.find(indexId, pageOptions)
#       respondToAjax TestResponses.pages.findSuccess

#     async.it "returns theme from cache", (done) ->
#       theme = Rev.Theme.find(themeId)
#       respondToAjax TestResponses.themes.findSuccess
#       waitForSync ->
#         belongs = page.get("theme")
#         expect(belongs.get("pageIds")).toEqual themeJSON.theme.page_ids
#         expect(belongs.get("title")).toEqual themeJSON.theme.title
#         expect(belongs.get("id")).toEqual themeId
#         expect(belongs.get("pageIds")).toEqual theme.get("pageIds")
#         expect(belongs.get("title")).toEqual theme.get("title")
#         expect(belongs.get("id")).toEqual theme.get("id")
#         done()

#     async.it "returns theme from server", (done) ->
#       belongs = page.get("theme")
#       respondToAjax TestResponses.themes.findSuccess
#       waitForSync ->
#         expect(belongs.get("pageIds")).toEqual themeJSON.theme.page_ids
#         expect(belongs.get("title")).toEqual themeJSON.theme.title
#         expect(belongs.get("id")).toEqual themeId
#         done()

#   describe "retrieves parent page", ->
#     describe "retrieves from cache", ->
#       parent = child = null
#       beforeEach ->
#         parent = Rev.Page.find(indexId, pageOptions)
#         child = Rev.Page.find(childId, pageOptions)
#         requests = respondToAjax(TestResponses.pages.findSuccess, TestResponses.pages.childSuccess)
#         expect(requests.first().method).toEqual "GET"
#         expect(requests.first().url).toEqual "pages/#{indexId}?theme_id=#{themeId}"
#         expect(requests.last().method).toEqual "GET"
#         expect(requests.last().url).toEqual "pages/#{childId}?theme_id=#{themeId}"

#       it "is immediately successful", ->
#         expect(child.get("parent.id")).toEqual pageJSON.page.id
#         expect(child.get("parent.childIds")).toEqual pageJSON.page.child_ids
#         expect(child.get("parent.title")).toEqual pageJSON.page.title
#         expect(child.get("parent.id")).toEqual parent.get("id")
#         expect(child.get("parent.childIds")).toEqual parent.get("childIds")
#         expect(child.get("parent.title")).toEqual parent.get("title")

#   describe "lists all assets", ->
#     beforeEach ->
#       runs ->
#         PreloadStore.store "theme_assets?theme_id=#{themeId}", assetsJSON
#         PreloadStore.store "pages?theme_id=#{themeId}", pagesJSON
#         PreloadStore.store "themes", themesJSON
#         themes = Rev.Theme.findAll()
#         pages = Rev.Page.findAll(pageOptions)
#         assets = Rev.ThemeAsset.findAll(pageOptions)
#       waits 10

#     async.it "has javascripts", (done) ->
#       page = Rev.Page.find(childId, pageOptions)
#       page.then (page) ->
#         page.get("javascripts").then (javascripts) ->
#           expect(javascripts.get("length")).toEqual 2
#         done()

#     async.it "has stylesheets", (done) ->
#       page = Rev.Page.find(childId, pageOptions)
#       page.then (page) ->
#         page.get("stylesheets").then (stylesheets) ->
#           expect(stylesheets.get("length")).toEqual 2
#         done()

#   describe "lists all child pages", ->
#     beforeEach ->
#       runs ->
#         pages = Rev.Page.findAll(pageOptions)
#         request = respondToAjax(TestResponses.pages.findAllSuccess)
#       waits 10
#       runs ->
#         page = Rev.Page.find(indexId, pageOptions)
#         request = respondToAjax(TestResponses.pages.findSuccess)
#       waits 10

#     async.it "returns list from cache", (done) ->
#       children = page.get("children")
#       children.then ->
#         expect(children.get("length")).toEqual 3
#         done()

#     async.it "returns list from server", (done) ->
#       expect(1).toBe 1
#       done()
