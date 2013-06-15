# describe "Rev.ThemeAsset", ->
#   async = new AsyncSpec(this)
#   beforeEach ->
#     setupAjax()

#   afterEach ->
#     clearAll()

#   describe "find from cache", ->
#     themes = undefined
#     theme = undefined
#     pages = undefined
#     assets = undefined
#     foundAssets = undefined
#     asset = undefined
#     foundAsset = undefined
#     beforeEach ->
#       setupPreload()
#       assets = Rev.ThemeAsset.findAll(theme_id: themeId)
#       pages = Rev.Page.findAll(theme_id: themeId)
#       themes = Rev.Theme.findAll()

#     async.it "findAll for theme", (done) ->
#       assets.then ->
#         expect(assets.get("length")).toEqual 5
#         done()


#     async.it "has many pages", (done) ->
#       stylesheet = undefined
#       assets.then ->
#         stylesheet = Rev.ThemeAsset.find(stylesheetId,
#           theme_id: themeId
#         )
#         stylesheet.get("pages").then (pages) ->
#           expect(pages.get("length")).toEqual 2
#           done()



#     async.it "belongs to a theme", (done) ->
#       stylesheet = undefined
#       assets.then ->
#         stylesheet = Rev.ThemeAsset.find(stylesheetId,
#           theme_id: themeId
#         )
#         stylesheet.get("theme").then (theme) ->
#           expect(theme.get("slug")).toEqual "test_theme"
#           done()
