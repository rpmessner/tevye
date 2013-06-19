# describe "Rev.Theme", ->
#   promise = theme = themes = theme = request = null
#   async = new AsyncSpec(this)
#   beforeEach ->
#     setupAjax()

#   afterEach ->
#     promise = themes = request = theme = request = null
#     clearAll()

#   describe "findAll from server", ->
#     beforeEach ->
#       themes = Rev.Theme.findAll()
#       request = respondToAjax(TestResponses.themes.findAllSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "themes"
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(themes.get("content").first().get("id")).toEqual themeId
#         done()

#   describe "findAll from preload", ->
#     beforeEach ->
#       PreloadStore.store "themes", themesJSON
#       themes = Rev.Theme.findAll()
#       request = mostRecentAjaxRequest()
#       expect(request).toBeNull()

#     async.it "can be successfull", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(themes.get("content").first().get("id")).toEqual themeId
#         done()

#   describe "find from server", ->
#     beforeEach ->
#       theme = Rev.Theme.find(themeId)
#       request = respondToAjax(TestResponses.themes.findSuccess)
#       themes = Rev.Theme.findAll()
#       request = respondToAjax(TestResponses.themes.findAllSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "themes/" + themeId
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(theme.get("id")).toEqual themeId
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "find with string keys", ->
#     beforeEach ->
#       PreloadStore.store "themes", themesJSON
#       themes = Rev.Theme.findAll()
#       theme = Rev.Theme.find(themeId + "")

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(theme.get("id")).toEqual themeId
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "find from preload cache", ->
#     beforeEach ->
#       PreloadStore.store "themes", themesJSON
#       themes = Rev.Theme.findAll()
#       theme = Rev.Theme.find(themeId)
#       request = respondToAjax(TestResponses.themes.findSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "themes/" + themeId
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(theme.get("id")).toEqual themeId
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "find from cache", ->
#     beforeEach ->
#       themes = Rev.Theme.findAll()
#       request = respondToAjax(TestResponses.themes.findAllSuccess)
#       theme = Rev.Theme.find(themeId)
#       request = respondToAjax(TestResponses.themes.findSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.url).toBe "themes/#{themeId}"
#       expect(request.method).toBe "GET"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 1
#         expect(theme.get("id")).toEqual themeId
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "find with error response", ->
#     beforeEach ->
#       theme = Rev.Theme.find(10000000000000)
#       request = respondToAjax(TestResponses.themes.findError)

#     async.it "can callback to promise error", (done) ->
#       theme.then ((model) ->
#         expect(false).toEqual true
#         done()
#       ), (error) ->
#         expect(error.id).toBe "Not Found"
#         done()

#   describe "create with id & attributes", ->
#     attributes = themeJSON.theme
#     it "is immediately successful", ->
#       theme = Rev.Theme.create(attributes)
#       expect(theme.get("page_ids")).toBeUndefined()
#       expect(theme.get("pageIds").sort()).toEqual pageIds.sort()

#     async.it "provides a promise", (done) ->
#       theme = Rev.Theme.create(attributes)
#       theme.then (model) ->
#         expect(model.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "create without id", ->
#     attributes = title: "test-theme-2"
#     beforeEach ->
#       themes = Rev.Theme.findAll()
#       request = respondToAjax(TestResponses.themes.findAllSuccess)
#       theme = Rev.Theme.create(attributes)
#       request = respondToAjax(TestResponses.themes.createSuccess)
#       expect(request.responseHeaders["Content-type"]).toBe "application/json"
#       expect(request.method).toBe "POST"
#       expect(request.url).toBe "themes"

#     async.it "can be successful", (done) ->
#       waitForSync ->
#         expect(themes.get("length")).toEqual 2
#         expect(theme.get("title")).toEqual "test-theme-2"
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#     async.it "provides a promise", (done) ->
#       theme.then (model) ->
#         expect(themes.get("length")).toEqual 2
#         expect(theme.get("title")).toEqual "test-theme-2"
#         expect(theme.get("pageIds").sort()).toEqual pageIds.sort()
#         done()

#   describe "create with error response", ->
#     promise = undefined
#     beforeEach ->
#       theme = Rev.Theme.create({})
#       request = respondToAjax(TestResponses.themes.createError)

#     async.it "can callback to promise error", (done) ->
#       theme.then ((model) ->
#         expect(false).toEqual true
#         done()
#       ), (error) ->
#         expect(error.errors.slug).toEqual ["can't be blank"]
#         expect(theme.get('errors.slug')).toEqual error.errors.slug

#         expect(error.errors.title).toEqual ["can't be blank"]
#         expect(theme.get('errors.title')).toEqual error.errors.title
#         done()

#   describe "destroy", ->
#     beforeEach ->
#       theme = Rev.Theme.create(themeJSON.theme)
#       spyOn(theme, "destroy").andCallThrough()
#       theme.destroyModel()
#       request = respondToAjax(TestResponses.themes.deleteSuccess)
#       expect(request.method).toBe "DELETE"
#       expect(request.url).toBe "themes/" + themeId

#     async.it "is successful", (done) ->
#       waitForSync ->
#         expect(theme.destroy).toHaveBeenCalled()
#         expect(theme.isDestroyed).toEqual true
#         done()

#   describe "update", ->
#     beforeEach ->
#       theme = Rev.Theme.create(themeJSON.theme)
#       theme.update slug: "hi"
#       request = respondToAjax(TestResponses.themes.updateSuccess)
#       expect(request.method).toBe "PUT"
#       expect(request.url).toBe "themes/" + themeId

#     async.it "is successful", (done) ->
#       theme.then ->
#         expect(theme.get("slug")).toEqual "hi"
#         done()

#   describe "lists all assets & images", ->
#     beforeEach ->
#       theme = Rev.Theme.find(themeId)
#       request = respondToAjax(TestResponses.themes.findSuccess)

#     async.it "returns list from cache", (done) ->
#       Rev.ThemeAsset.findAll pageOptions
#       request = respondToAjax(TestResponses.assets.findAll)
#       waitForSync ->
#         images = theme.get("images")
#         assets = theme.get("themeAssets")
#         waitForSync ->
#           expect(assets).toBeDefined()
#           expect(assets.get("length")).toEqual 5
#           expect(images).toBeDefined()
#           expect(images.get("length")).toEqual 1
#           expect(assets).toContain images.get("firstObject")
#           done()

#   describe "lists all pages", ->
#     beforeEach ->
#       theme = Rev.Theme.find(themeId)
#       request = respondToAjax(TestResponses.themes.findSuccess)

#     async.it "returns list from cache", (done) ->
#       Rev.Page.findAll pageOptions
#       request = respondToAjax(TestResponses.pages.findAllSuccess)
#       waitForSync ->
#         pages = theme.get("pages")
#         pages.then ->
#           expect(pages.get("length")).toEqual pageIds.length
#           done()

#     async.it "returns list from cache via promise", (done) ->
#       Rev.Page.findAll pageOptions
#       request = respondToAjax(TestResponses.pages.findAllSuccess)
#       pages = theme.get("pages")
#       pages.then ->
#         expect(pages.get("length")).toEqual pageIds.length
#         done()

#     async.it "returns list from server", (done) ->
#       pages = theme.get("pages")
#       request = respondToAjax(TestResponses.pages.findAllSuccess)
#       waitForSync ->
#         expect(pages.get("length")).toEqual pageIds.length
#         done()

#     async.it "returns list from server via promise", (done) ->
#       pages = theme.get("pages")
#       request = respondToAjax(TestResponses.pages.findAllSuccess)
#       pages.then ->
#         expect(pages.get("length")).toEqual pageIds.length
#         done()
