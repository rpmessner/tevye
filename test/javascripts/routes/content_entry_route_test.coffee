article_id = articles_json.content_entries[0].id
isPresent = Tevye.isPresent

module "ContentEntryRoute",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "renders a table listing all entries", ->
  visit("/sites/#{site_id}/content_types/#{articles_type_id}/content_entries/#{article_id}").then ->
    waitForRender ->
      entry_controller = lookup("controller:contentEntry")
      entry = entry_controller.get("content")

      equal entry.get('id'), article_id

      entry_view = getRegisteredView("contentEntry")
      ok isPresent entry_view

      form_view = getChildViewByName(entry_view, /FormView/)
      ok isPresent form_view
      deepEqual form_view.get('controller'), entry_controller

      start()
