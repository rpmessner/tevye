isPresent       = Tevye.isPresent
getCodePaneView = (router) ->
  getChildViewByName getPageView(), /CodePane/

module "PageRoute",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "renders a code view for page stylesheets (shared)", ->
  visit("/sites/#{site_id}/pages/#{child_id}").then ->
    waitForRender ->
      stylesheet = lookup("controller:themeAssets").get("selectedStylesheet")
      pane_view = getCodePaneView()
      code_view = pane_view.get("stylesheetView")

      ok isPresent code_view

      code_view.$(".select").simulate 'click'
      equal code_view.$("select").length, 1
      equal code_view.$("select option").length, 1

      mirror = code_view.get("mirror")
      equal mirror.doc.mode.name, stylesheet.get("mode")

      start()

asyncTest "renders a code view for page javascripts (shared)", ->
  visit("/sites/#{site_id}/pages/#{child_id}").then ->
    waitForRender ->
      javascript = lookup("controller:themeAssets").get("selectedJavascript")
      pane_view = getCodePaneView()
      code_view = pane_view.get("javascriptView")

      ok isPresent code_view

      code_view.$(".select").simulate 'click'
      equal code_view.$("select").length, 1
      equal code_view.$("select option").length, 3

      mirror = code_view.get("mirror")
      equal mirror.doc.mode.name, javascript.get("mode")

      start()

asyncTest "renders a code view for the page template", ->
  visit("/sites/#{site_id}/pages/#{child_id}").then ->
    waitForRender ->
      pane_view = getCodePaneView()
      code_view = pane_view.get("templateView")

      ok isPresent code_view

      mirror = code_view.get("mirror")
      equal mirror.doc.mode.name, "htmlembedded"

      start()

asyncTest "renders a preview with rendered template/javascript/stylesheet", ->
  visit("/sites/#{site_id}/pages/#{child_id}").then ->
    waitForRender ->
      page_view = getPageView()
      pre_view = getChildViewsByName(page_view, /PreviewView/)

      ok isPresent pre_view

      start()
