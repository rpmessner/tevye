# describe "Rev.ThemesRoute", ->
#   async = new AsyncSpec(@)
#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes"

#   afterEach ->
#     window.location.hash = ""
#     clearAll()

#   async.it "renders nav view listing themes", (done) ->
#     waitForRender ->
#       themes = lookup("controller:themes").get("content")
#       expect(themes.get("length")).toEqual(1)
#       themesView = getRegisteredView("themes")

#       navView = getChildViewByName(themesView, /NavigationView/)

#       expect(navView).toBeDefined()
#       expect(navView.$("a.theme-link").length).toEqual(1)
#       expect(navView.$("a.theme-link").attr("href")).toEqual "#/themes/#{themeId}"
#       expect(navView.$("a.theme-assets").length).toEqual(0)
#       expect(navView.$("a.current-theme").length).toEqual(0)
#       done()
