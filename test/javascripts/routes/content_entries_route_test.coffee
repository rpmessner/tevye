num_articles = articles_json.content_entries.length
isPresent = Tevye.isPresent

module 'ContentEntriesRoute',
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest 'renders a table listing all entries', ->
  visit("/sites/#{site_id}/content_types/#{articles_type_id}/content_entries").then ->
    waitForRender ->
      entries = lookup('controller:content_entries').get('content')
      equal entries.get('length'), num_articles

      entries_view = getRegisteredView('contentEntries')
      ok isPresent entries_view

      entries_index_view = getRegisteredView('contentEntries.index')
      ok isPresent entries_index_view
      deepEqual entries_index_view.get('controller.content'), entries
      equal entries_index_view.$('table.content-entries tr').length, num_articles + 1

      start()
