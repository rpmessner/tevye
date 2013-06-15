# describe 'Rev.ContentEntriesRoute', ->
#   async = new AsyncSpec(this)
#   numRecipes = recipesJSON.content_entries.length

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}/content_types/#{recipesId}/content_entries"

#   afterEach ->
#     window.location.hash = ''
#     clearAll()

#   async.it 'renders a table listing all entries', (done) ->
#     waitForRender ->
#       entries = lookup('controller:content_entries').get('content')
#       expect(entries.get('length')).toEqual(numRecipes)
#       entriesView = getRegisteredView('contentEntries')
#       expect(entriesView).toBeDefined()

#       entriesIndexView = getRegisteredView('contentEntries.index')

#       expect(entriesIndexView).toBeDefined()
#       expect(entriesIndexView.get('controller.content')).toEqual(entries)
#       expect((entriesIndexView.$('table.content-entries tr') || $('')).length).toEqual(numRecipes + 1)

#       done()
