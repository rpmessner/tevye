isPresent = Tevye.isPresent
num_types = content_types_json.content_types.length

module 'ContentTypesRoute',
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest 'renders a table listing all entries', ->
  visit("/sites/#{site_id}/content_types").then ->
    waitForRender ->
      types = lookup('controller:contentTypes').get('content')
      equal types.get('length'), num_types

      types_view = getRegisteredView('contentTypes')
      ok isPresent types_view

      types_index_view = getRegisteredView('contentTypes.index')
      ok isPresent types_index_view
      equal types_index_view.get('controller.content'), types
      equal types_view.$('table.content-types tr').length, num_types + 1

      start()
