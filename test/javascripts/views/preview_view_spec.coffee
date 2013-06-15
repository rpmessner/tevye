# describe "Rev.PreviewView", ->
#   pages =  themes = assets = stylesheets = javascripts = preView = child = index = null
#   async = new AsyncSpec(this)
#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#       assets = Rev.ThemeAsset.findAll(pageOptions)
#       pages = Rev.Page.findAll(pageOptions)
#       themes = Rev.Theme.findAll()
#     waits 10
#     runs ->
#       index = Rev.Page.find(indexId, pageOptions)
#       child = Rev.Page.find(childId, pageOptions)
#       preView = Rev.PreviewView.create(controller: Rev.ItemController.create(content: index))
#       Ember.run ->
#         preView.append()
#     waits 10

#   afterEach ->
#     preView.destroy()
#     preView = null
#     clearAll()

#   async.it "should render", (done) ->
#     waitForRender ->
#       expect(preView.isVisible).toBeTruthy()
#       done()

#   async.it "should render an iframe for the preview", (done) ->
#     waitForRender ->
#       expect(preView.$("iframe").length).toEqual 1
#       done()

#   async.it "iframe body should correspond to controller page", (done) ->
#     waitForRender ->
#       expect(preView.get('iframeSrc')).toMatch "pages/#{indexId}/preview"
#       done()

#   async.it "should change url when content changed", (done) ->
#     preView.set('controller.content', child)
#     waitForRender ->
#       expect(preView.get('iframeSrc')).toMatch "pages/#{childId}/preview"
#       done()
