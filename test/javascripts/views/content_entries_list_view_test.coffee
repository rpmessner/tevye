isPresent = Tevye.isPresent
isBlank = Tevye.isBlank

getContentTypesListView = ->
  getChildViewByName lookupView('site'), /ContentTypesListView/

getContentEntriesListView = ->
  getChildViewByName lookupView('site'), /ContentEntriesListView/

module "ContentEntriesListView",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "should be created", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      list_view = getContentEntriesListView()
      ok isPresent list_view

      start()

asyncTest "recieves the content types controller for the current site", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      controller = lookup('controller:contentEntries')
      ok isPresent controller
      ok isBlank controller.get("content")

      types_list_view = getContentTypesListView()
      types_list_view.$(".select:first").simulate('click')
      waitForRender ->
        equal controller.get("content.firstObject.siteId"), site_id

        list_view = getContentEntriesListView()
        equal list_view.get("controller"), controller

        start()
