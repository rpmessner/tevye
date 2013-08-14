types = controller = list_view = null
isPresent = Tevye.isPresent
getContentTypesListView = ->
  getChildViewByName lookupView("site"), /ContentTypesListView/

module "ContentTypesListView",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "should be created", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentTypesListView()
      ok isPresent list_view
      start()

asyncTest "should recieve the content types controller for the current theme", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentTypesListView()
      controller = lookup("controller:contentTypes")

      ok isPresent controller
      equal controller.get("content.firstObject.siteId"), site_id
      deepEqual list_view.get("controller"), controller
      start()

asyncTest "should render proper tags & classes for each element", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentTypesListView()
      equal list_view.$("ul.nav").length, 1
      equal list_view.$("ul").length, 1
      equal list_view.$("li").length, 7
      start()

asyncTest "editing", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentTypesListView()

      equal list_view.$(".active").length, 0
      equal allContentTypeLinks(list_view).length, 7
      equal allContentTypeLinks(list_view).first().attr("href"),
        "/sites/#{site_id}/content_types/#{projects_type_id}"

      editIcons(list_view).first().simulate('click')
      waitForRender ->
        equal lookup("controller:contentType").get("content.id"), projects_type_id
        equal list_view.$(".active").length, 1
        start()

asyncTest "selecting", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentTypesListView()
      equal list_view.$(".selected").length, 0
      equal list_view.$(".select").length, 7
      list_view.$(".select").first().simulate('click')
      waitForRender ->
        equal lookup("controller:contentTypes").get("selected.id"), projects_type_id
        equal list_view.$(".selected").length, 1
        start()
