# describe "Rev.Sortable", ->
#   contentEntries = undefined
#   sortableViewClass = undefined
#   sortableView = undefined
#   firstItem = undefined
#   secondItem = undefined
#   lastItem = undefined
#   firstView = undefined
#   secondView = undefined
#   lastView = undefined
#   ithView = undefined
#   async = new AsyncSpec(this)
#   beforeEach ->
#     runs ->
#       setupPreload()
#       setupAjax()
#       contentEntries = Rev.ContentEntry.findAll(contentEntryOptions)
#       sortableViewClass = Em.CollectionView.extend(Rev.Sortable,
#         itemViewClass: Em.View.extend(Rev.SortableItem,
#           template: Em.Handlebars.compile("{{ view.content.title }}")
#         )
#         onSort: (firstObject, secondObject) ->
#       )
#     waits 10
#     runs ->
#       sortableView = sortableViewClass.create(sortableContent: contentEntries)

#   afterEach ->
#     sortableView.destroy()
#     sortableView = sortableViewClass = null
#     clearAll()

#   async.it "should render to page", (done) ->
#     Ember.run ->
#       sortableView.append()

#     waitForRender ->
#       expect(sortableView).toBeDefined()
#       expect(sortableView.$()).toBeDefined()
#       done()

#   async.it "should render the correct tags", (done) ->
#     Ember.run ->
#       sortableView.append()

#     waitForRender ->
#       expect(sortableView.$()[0].tagName).toEqual "UL"
#       expect(sortableView.get("childViews.firstObject").$()[0].tagName).toEqual "LI"
#       done()

#   async.it "drag the top item into the middle position", (done) ->
#     Ember.run ->
#       sortableView.append()

#     waitForRender ->
#       spy = callback: (source, target) ->

#       spyOn(spy, "callback").andCallThrough()
#       sortableView.set "onSort", spy.callback
#       ithView = (i) ->
#         ->
#           sortableView.get("childViews")[i]

#       firstView = ithView(0)
#       secondView = ithView(1)
#       lastView = ithView(2)
#       firstItem = firstView().get("content")
#       secondItem = secondView().get("content")
#       lastItem = lastView().get("content")
#       drag(firstView().$()).onto secondView().$(),
#         afterDragStart: (event) ->
#           expect(firstItem.get("isDragging")).toBeTruthy()
#           expect(secondItem.get("isDragging")).toBeFalsy()
#           expect(lastItem.get("isDragging")).toBeFalsy()
#           expect(firstView().$().hasClass("placeholder")).toBeTruthy()
#           expect(secondView().$().hasClass("placeholder")).toBeFalsy()
#           expect(lastView().$().hasClass("placeholder")).toBeFalsy()

#         afterDragOver: (event) ->
#           expect(event.preventDefault).toHaveBeenCalled()

#         afterDragEnter: (event) ->
#           expect(secondView().get("content")).toEqual firstItem
#           expect(firstView().get("content")).toEqual secondItem
#           expect(secondItem.get("position")).toEqual 0
#           expect(firstItem.get("position")).toEqual 1
#           expect(firstView().$().html()).toMatch secondItem.get("title")
#           expect(event.preventDefault).toHaveBeenCalled()

#         afterDrop: (event) ->
#           expect(firstView().$().hasClass("placeholder")).toBeFalsy()
#           expect(secondView().$().hasClass("placeholder")).toBeFalsy()
#           expect(lastView().$().hasClass("placeholder")).toBeFalsy()
#           expect(secondItem.get("isDragging")).toBeFalsy()
#           expect(firstItem.get("isDragging")).toBeFalsy()
#           expect(lastItem.get("isDragging")).toBeFalsy()
#           expect(spy.callback).toHaveBeenCalledWith firstItem, secondItem
#           done()
