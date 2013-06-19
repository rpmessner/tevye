# describe "content types and entries", ->
#   async = new AsyncSpec(this)
#   contentEntries = undefined
#   contentTypes = undefined
#   themes = undefined
#   pages = undefined
#   assets = undefined
#   beforeEach ->
#     setupAjax()
#     setupPreload()
#     assets = Rev.ThemeAsset.findAll(pageOptions)
#     pages = Rev.Page.findAll(pageOptions)
#     themes = Rev.Theme.findAll()
#     contentTypes = Rev.ContentType.findAll(pageOptions)
#     contentEntries = Rev.ContentEntry.findAll(contentEntryOptions)

#   afterEach ->
#     clearAll()

#   describe "Rev.ContentType", ->
#     async.it "should be created", (done) ->
#       waitForSync ->
#         expect(contentTypes.get("length")).toEqual 2
#         done()


#     async.it "embeds many custom fields", (done) ->
#       waitForSync ->
#         expect(contentTypes.get("firstObject.customFields.length")).toEqual 4
#         expect(contentTypes.get("firstObject.customFields.firstObject.type")).toEqual "string"
#         expect(contentTypes.get("firstObject.customFields.lastObject.type")).toEqual "has_many"
#         done()


#     async.it "belongs to a theme", (done) ->
#       waitForSync ->
#         recipes = Rev.ContentType.find(recipesId, pageOptions)
#         recipes.then (type) ->
#           expect(type.get("theme.id")).toEqual themes.get("firstObject.id")
#           expect(type.get("theme.pageIds")).toEqual themes.get("firstObject.pageIds")
#           done()

#     async.it "has many entries", (done) ->
#       waitForSync ->
#         recipes = Rev.ContentType.find(recipesId, pageOptions)
#         recipes.then (type) ->
#           type.get("entries").then (entries) ->
#             expect(entries.get("firstObject.id")).toEqual contentEntries.get("firstObject.id")
#             expect(entries.get("firstObject.title")).toEqual contentEntries.get("firstObject.title")
#             done()

#   describe "Rev.ContentEntry", ->
#     async.it "should be created", (done) ->
#       waitForSync ->
#         expect(contentEntries.get("length")).toEqual 3
#         done()

#     async.it "belongs to a theme", (done) ->
#       waitForSync ->
#         expect(contentEntries.get("firstObject.theme.id")).toEqual themeId
#         done()

#     async.it "belongs to a type", (done) ->
#       waitForSync ->
#         expect(contentEntries.get("firstObject.contentType.id")).toEqual recipesId
#         done()
