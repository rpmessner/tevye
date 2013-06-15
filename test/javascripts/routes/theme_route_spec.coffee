# describe "Rev.ThemeRoute", ->
#   async = new AsyncSpec(this)

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}"

#   afterEach ->
#     window.location.hash = ""
#     clearAll()

#   async.it "renders nav view with theme specific options", (done) ->
#     waitForRender ->
#       themeController  = lookup("controller:theme")
#       themesController = lookup("controller:themes")
#       theme            = themeController.get('content')
#       themes           = themesController.get('content')
#       themesView       = getRegisteredView('themes')
#       themeView        = getRegisteredView('theme')
#       navView          = getChildViewByName(themesView, /NavigationView/)

#       expect(themeController.get("showImages")).toBeFalsy()
#       expect(themesController.get("selected")).toEqual(theme)
#       expect(themes.get("length")).toEqual(1)
#       expect(themeView.$("img").length).toEqual(0)
#       expect(navView).toBeDefined()
#       expect(navView.$("a.current-theme").length).toEqual(1)
#       expect(navView.$("a.theme-assets").length).toEqual(1)
#       expect(navView.$("a.current-theme").attr("href")).toEqual("#")
#       click(navView.$("a.theme-assets"))
#       waitForRender ->
#         expect(themeController.get("showImages")).toBeTruthy()
#         expect(themeView.$("img").length).toEqual(1)
#         done()
