# describe 'Rev.ContentTypesRoute', ->
#   async = new AsyncSpec(@)
#   numTypes = contentTypesJSON.content_types.length

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}/content_types"

#   afterEach ->
#     window.location.hash = ''
#     clearAll()

#   async.it 'renders a table listing all entries', (done) ->
#     waitForRender ->
#       types = lookup('controller:content_types').get('content')
#       expect(types.get('length')).toEqual(numTypes)

#       typesView = getRegisteredView('contentTypes')
#       expect(typesView).toBeDefined()

#       typesIndexView = getRegisteredView('contentTypes.index')
#       expect(typesIndexView).toBeDefined()
#       expect(typesIndexView.get('controller.content')).toEqual(types)
#       expect((typesView.$('table.content-types tr') || $('')).length).toEqual(numTypes + 1)

#       done()
