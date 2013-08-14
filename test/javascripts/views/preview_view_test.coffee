pages = sites = assets = pre_view = child = index = null
isPresent = Tevye.isPresent

module "PreviewView",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
    assets = Tevye.ThemeAsset.findAll(page_options)
    pages = Tevye.Page.findAll(page_options)
    sites = Tevye.Site.findAll()
    waitForSync ->
      index = Tevye.Page.find(index_id, page_options)
      child = Tevye.Page.find(child_id, page_options)
      pre_view = Tevye.PreviewView.create(controller: Tevye.ItemController.create(content: index))
      pre_view.appendTo('#ember-testing')
  teardown: clearAll.compose ->  pre_view.destroy()

asyncTest "should render", ->
  waitForRender ->
    ok isPresent pre_view
    ok pre_view.isVisible
    start()

asyncTest "should render an iframe for the preview", ->
  waitForRender ->
    equal pre_view.$("iframe").length, 1
    start()

asyncTest "iframe body should correspond to controller page", ->
  waitForRender ->
    equal pre_view.get('iframeSrc'), "http://#{window.location.host}/#{index.get('url')}"
    start()

asyncTest "should change url when content changed", ->
  waitForRender ->
    pre_view.set('controller.content', child)
    waitForRender ->
      equal pre_view.get('iframeSrc'), "http://#{window.location.host}/#{child.get('url')}"
      start()
