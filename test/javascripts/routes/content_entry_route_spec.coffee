# describe "Rev.ContentEntryRoute", ->
#   async = new AsyncSpec(this)
#   recipeId = recipesJSON.content_entries[0].id

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}/content_types/#{recipesId}/content_entries/#{recipeId}"

#   afterEach ->
#     window.location.hash = ""
#     clearAll()

#   async.it "renders a table listing all entries", (done) ->
#     waitForRender ->
#       entryController = lookup("controller:contentEntry")
#       entry = entryController.get("content")

#       expect(entry.get('id')).toEqual(recipeId)

#       entryView = getRegisteredView("contentEntry")
#       expect(entryView).toBeDefined()

#       formView = getChildViewByName(entryView, /FormView/)
#       expect(formView).toBeDefined()
#       expect(formView?.get('controller')).toEqual(entryController)

#       done()
