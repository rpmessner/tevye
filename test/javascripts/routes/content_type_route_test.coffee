isPresent = Tevye.isPresent

module "ContentEntryRoute",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "renders a type form", ->
  visit("/sites/#{site_id}/content_types/#{articles_type_id}").then ->
    waitForRender ->
      types_controller = lookup("controller:contentTypes")
      type_controller = lookup("controller:contentType")
      type = type_controller.get('content')

      deepEqual types_controller.get('selected'), type
      equal type.get('id'), articles_type_id

      type_view = getRegisteredView('contentType')
      ok isPresent type_view

      type_index_view = getRegisteredView('contentType.index')
      ok isPresent type_index_view

      form_view = getChildViewByName(type_index_view, /FormView/)
      ok isPresent form_view
      deepEqual form_view.get('controller'), type_controller

      start()
