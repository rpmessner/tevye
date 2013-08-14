sortable_view = null
isBlank = Tevye.isBlank
isPresent = Tevye.isPresent
setupAll = -> Ember.run Tevye, Tevye.advanceReadiness
module "SortableView",
  setup: setupAll.compose setupPreload.andThen ->
    content_entries = Tevye.ContentEntry.findAll content_entry_options
    content_entries.then (content_entries) ->
      view_class = Em.CollectionView.extend Tevye.Sortable,
        itemViewClass: Em.View.extend Tevye.SortableItem,
          template: Em.Handlebars.compile("{{ view.content.title }}")
        onSort: (firstObject, secondObject) -> debugger
      sortable_view = view_class.create(sortableContent: content_entries)
      Ember.run -> sortable_view.appendTo('#ember-testing')

  teardown: clearAll.andThen ->
    sortable_view.remove()
    sortable_view.destroy()
    sortable_view = null

asyncTest "should render to page", ->
  waitForRender ->
    ok isPresent sortable_view
    ok isPresent sortable_view.$()
    start()

asyncTest "should render the correct tags", ->
  waitForRender ->
    equal sortable_view.$()[0].tagName, "UL"
    equal sortable_view.get("childViews.firstObject").$()[0].tagName, "LI"
    start()

asyncTest "drag the top item into the second position and back", ->
  waitForRender ->
    ithView = (i) -> -> sortable_view.get("childViews")[i]

    first_view = ithView(0)
    second_view = ithView(1)

    first_item = first_view().get("content")
    second_item = second_view().get("content")

    ok !sortable_view.get('isDragging')

    first_view().$().simulate("mousedown")
    ok sortable_view.get('isDragging')

    second_view().$().trigger("mouseenter")
    equal first_view().get('content.id'), second_item.get('id')
    equal second_view().get('content.id'), first_item.get('id')

    first_view().$().trigger("mouseenter")
    equal first_view().get('content.id'), first_item.get('id')
    equal second_view().get('content.id'), second_item.get('id')

    first_view().$().simulate("mouseup")
    ok !sortable_view.get('isDragging')

    start()
