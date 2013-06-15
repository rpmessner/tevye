# describe "Rev.PageRoute", ->
#   async = new AsyncSpec(this)
#   beforeEach ->
#     runs ->
#       setupAjax()
#       setupPreload()
#     waits 10
#     runs ->
#       window.location.hash = "#/themes/#{themeId}/pages/#{childId}"

#   # afterEach ->
#   #   window.location.hash = ""
#   #   clearAll()

#   # async.it "renders a code view for page stylesheets (shared)", (done) ->
#   #   waitForRender ->
#   #     stylesheet = lookup("controller:page").get("selectedStylesheet")
#   #     paneView = getCodePaneView()
#   #     codeView = paneView.get("stylesheetView")
#   #     expect(codeView).toBeDefined()
#   #     expect(codeView.$("select").length).toEqual 1
#   #     expect(codeView.$("select option").length).toEqual 2
#   #     mirror = codeView.get("mirror")
#   #     expect(mirror.doc.mode.name).toEqual stylesheet.get("mode")
#   #     done()

#   # async.it "renders a code view for page javascripts (shared)", (done) ->
#   #   waitForRender ->
#   #     javascript = lookup("controller:page").get("selectedJavascript")
#   #     paneView = getCodePaneView()
#   #     codeView = paneView.get("javascriptView")
#   #     expect(codeView).toBeDefined()
#   #     expect(codeView.$("select").length).toEqual 1
#   #     expect(codeView.$("select option").length).toEqual 2
#   #     mirror = codeView.get("mirror")
#   #     expect(mirror.doc.mode.name).toEqual javascript.get("mode")
#   #     done()

#   # async.it "renders a code view for the page template", (done) ->
#   #   waitForRender ->
#   #     paneView = getCodePaneView()
#   #     codeView = paneView.get("templateView")
#   #     expect(codeView).toBeDefined()
#   #     mirror = codeView.get("mirror")
#   #     expect(mirror.doc.mode.name).toEqual "htmlembedded"
#   #     done()

#   async.it "renders a preview with rendered template/javascript/stylesheet", (done) ->
#     waitForRender ->
#       pageView = getPageView()
#       preView = getChildViewsByName(pageView, /PreviewView/)
#       expect(preView).toBeDefined()
#       done()
