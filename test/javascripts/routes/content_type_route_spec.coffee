# describe "Rev.ContentTypeRoute", ->
#   async = new AsyncSpec(@)

#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}/content_types/#{recipesId}"

#   afterEach ->
#     window.location.hash = ""
#     clearAll()

#   async.it "renders a type form", (done) ->
#     waitForRender ->
#       typesController = lookup("controller:contentTypes")
#       typeController = lookup("controller:contentType")
#       type = typeController.get('content')

#       expect(typesController.get('selected')).toEqual(type)
#       expect(type.get('id')).toEqual(recipesId)

#       typeView = getRegisteredView('contentType')
#       expect(typeView).toBeDefined()

#       typeIndexView = getRegisteredView('contentType.index')
#       expect(typeIndexView).toBeDefined()

#       formView = getChildViewByName(typeIndexView, /FormView/)
#       expect(formView).toBeDefined()
#       expect(formView.get('controller')).toEqual(typeController)

#       done()
