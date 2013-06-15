# describe "Rev.ContentEntryFormView", ->
#   type = types = entry = entries = controller = formView = null
#   async = new AsyncSpec(this)

#   getCustomFieldView = (formView, fieldType) ->
#     formView.get("childViews").find (x) ->
#       x.get("content.type") is fieldType

#   beforeEach ->
#     runs ->
#       setupPreload()
#       setupAjax()
#       types = Rev.ContentType.findAll(pageOptions)
#       entries = Rev.ContentEntry.findAll(contentEntryOptions)

#     waits 10
#     runs ->
#       type = types.get("lastObject")
#       entry = entries.get("firstObject")
#       controller = Em.ObjectController.create(
#         content: entry
#         update: ->
#       )
#       spyOn controller, "update"
#       formView = Rev.ContentEntryFormView.create(controller: controller)


#   afterEach ->
#     formView.destroy()
#     formView = null
#     clearAll()

#   async.it "should be created", (done) ->
#     waitForRender ->
#       expect(formView).toBeDefined()
#       done()

#   describe "rendered", ->
#     beforeEach ->
#       Ember.run ->
#         formView.append()

#     async.it "should render", (done) ->
#       waitForRender ->
#         expect(formView.$()).toBeDefined()
#         done()

#     async.it "should render a child view for each custom field", (done) ->
#       waitForRender ->
#         types = Rev.ContentType.fieldValueTypes
#         fieldsView = formView.get("childViews.firstObject")
#         expect(fieldsView.get("childViews.length")).toEqual 8
#         fieldsView.get("childViews").forEach (fieldView) ->
#           expectedType = Em.get(types[fieldView.get("content.type")])
#           expect(expectedType).toBeDefined()
#           expect((expectedType or Em.Object.extend({})).detect(fieldView.constructor)).toBeTruthy()
#         done()

#     async.it "should render the correct input ui", (done) ->
#       waitForRender ->
#         fieldsView = formView.get("childViews.firstObject")
#         fieldsView.get("childViews").each (view) ->
#           expect(view.$("label").html()).toMatch view.get("customField.title")

#         fieldView = getCustomFieldView(fieldsView, "file")
#         expect(fieldView.$("input[type='file']").length).toEqual 1
#         expect(fieldView.$("input[type='hidden']").length).toEqual 1
#         expect(parseInt(fieldView.$("input[type='hidden']").val(), 10)).toEqual entry.get("imageId")
#         fieldView = getCustomFieldView(fieldsView, "select")
#         expect(fieldView.$("select").length).toEqual 1
#         expect(fieldView.$("option").length).toEqual 4
#         expect(fieldView.$("select").val()).toEqual entry.get("recipeType")
#         fieldView = getCustomFieldView(fieldsView, "bool")
#         expect(fieldView.$("input[type='radio']").length).toEqual 2
#         expect(fieldView.$("input[type='radio']:checked").length).toEqual 1
#         fieldView = getCustomFieldView(fieldsView, "text")
#         expect(fieldView.$("textarea").length).toEqual 1
#         expect(fieldView.$("textarea").val()).toEqual entry.get("ingredients")
#         fieldView = getCustomFieldView(fieldsView, "date")
#         expect(fieldView.$("input[type='hidden']").length).toEqual 1
#         expect(fieldView.$("input[type='hidden']").val()).toEqual entry.get("createdAtDate")
#         fieldView = getCustomFieldView(fieldsView, "string")
#         expect(fieldView.$("input[type='text'][name='title']").length).toEqual 1
#         expect(fieldView.$("input[type='text'][name='title']").val()).toEqual entry.get("title")
#         fieldView = getCustomFieldView(fieldsView, "has_many")
#         expect(fieldView.$("input[type='hidden']").length).toEqual 1
#         expect(fieldView.$("input[type='hidden']").val()).toEqual entry.get("productsIds").join(",")
#         expect(fieldView.$("select").length).toEqual 1
#         expect(fieldView.$("option").length).toEqual 3
#         fieldView = getCustomFieldView(fieldsView, "belongs_to")
#         expect(fieldView.$("input[type='hidden']").length).toEqual 1
#         expect(parseInt(fieldView.$("input[type='hidden']").val(), 10)).toEqual entry.get("featuredByProductId")
#         expect(fieldView.$("select").length).toEqual 1
#         expect(parseInt(fieldView.$("select").val(), 10)).toEqual entry.get("featuredByProductId")
#         expect(fieldView.$("option").length).toEqual 4
#         expect(formView.$("button.save").length).toEqual 1
#         click formView.$("button.save")
#         expect(formView.get("controller.update")).toHaveBeenCalled()
#         done()
