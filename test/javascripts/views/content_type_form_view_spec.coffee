# describe "Rev.ContentTypeFormView", ->
#   controller = type = types = formView = null

#   async = new AsyncSpec(this)

#   getCustomFieldView = (formView, fieldType) ->
#     formView.get("childViews").find (x) ->
#       x.get("content.type") is fieldType

#   beforeEach ->
#     runs ->
#       setupPreload()
#       setupAjax()
#       types = Rev.ContentType.findAll(pageOptions)
#     waits 10
#     runs ->
#       type = types.get("lastObject")
#       controller = Ember.ObjectController.create
#         update: ->
#         addCustomField: ->
#         removeCustomField: ->
#         content: type
#       spyOn controller, "update"
#       spyOn controller, "addCustomField"
#       spyOn controller, "removeCustomField"
#       window.testController = controller
#       formView = Rev.ContentTypeFormView.create(controller: controller)

#   afterEach ->
#     formView.destroy()
#     controller = type = types = formView = null
#     clearAll()

#   async.it "should be able to be created", (done) ->
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

#     async.it "should be able to be created", (done) ->
#       waitForRender ->
#         fieldsView = formView.get("childViews.firstObject")
#         expect(fieldsView.get("childViews.length")).toEqual 8
#         types = Rev.ContentType.fieldTypes
#         expect(Rev.Sortable.detect(fieldsView)).toBeTruthy()
#         done()

#     async.it "should allow creating new custom fields", (done) ->
#       waitForRender ->
#         click(formView.$('button.custom-field.new'))
#         select(formView.$('select[name="new-custom-field-type"]'), 'string')
#         typeText("Text Field").into(formView.$('input[name="new-custom-field-name"]')).andHitEnter()
#         expect(formView.get("controller.addCustomField")).toHaveBeenCalledWith
#           title: 'Text Field'
#           field_type: 'string'
#         done()

#     async.it "should allow removing existing custom fields", (done) ->
#       fieldsView = null
#       getLabelField = -> getCustomFieldView(fieldsView, "string")
#       waitForRender ->
#         fieldsView = formView.get("childViews.firstObject")

#         fieldView = getLabelField()
#         expect(fieldView.$('button.destroy').length).toEqual(0)

#         fieldView = getCustomFieldView(fieldsView, "text")
#         expect(fieldView.$('button.destroy').length).toEqual(1)

#         click(fieldView.$('button.destroy'))
#         expect(formView.get('controller.removeCustomField')).toHaveBeenCalledWith fieldView.get('content')

#         done()

#     async.it "should render the correct input ui", (done) ->
#       waitForRender ->
#         fieldsView = formView.get("childViews.firstObject")
#         fieldsView.get("childViews").each (view) ->
#           expect(view.$("input[type='text'][name='title']").val()).toMatch view.get("customField.title")
#           typeText("new-title").into view.$("input[type='text'][name='title']")
#           expect(view.get("content.title")).toEqual "new-title"
#           expect(view.$("input[type='radio']").length).toEqual 2
#           click view.$("input[type='radio']:last")
#           expect(view.get("content.required")).toBeTruthy()
#           click view.$("input[type='radio']:first")
#           expect(view.get("content.required")).toBeFalsy()

#         fieldView = getCustomFieldView(fieldsView, "text")
#         expect(fieldView.$("select[name='format']").length).toEqual 1
#         expect(fieldView.$("select[name='format']").val()).toEqual fieldView.get("content.format")
#         select fieldView.$("select[name=\"format\"]"), "markdown"
#         expect(fieldView.get("content.format")).toEqual "markdown"
#         expect(fieldView.$("option").length).toEqual 3

#         fieldView = getCustomFieldView(fieldsView, "belongs_to")
#         expect(fieldView.$("select[name='target']").length).toEqual 1
#         expect(fieldView.$("select[name='target'] option").length).toEqual 3
#         select fieldView.$("select[name=\"target\"]"), "products"
#         expect(fieldView.get("content.target")).toEqual "products"
#         expect(fieldView.$("select[name='inverse']").length).toEqual 1
#         expect(fieldView.$("select[name='inverse'] option").length).toEqual 3
#         select fieldView.$("select[name=\"inverse\"]"), "featured_recipes"
#         expect(fieldView.get("content.inverse_of")).toEqual "featured_recipes"

#         fieldView = getCustomFieldView(fieldsView, "has_many")
#         expect(fieldView.$("select[name='target']").length).toEqual 1
#         expect(fieldView.$("select[name='target'] option").length).toEqual 3
#         select fieldView.$("select[name=\"target\"]"), "recipes"
#         expect(fieldView.get("content.target")).toEqual "recipes"
#         expect(fieldView.$("select[name='inverse']").length).toEqual 1
#         expect(fieldView.$("select[name='target'] option").length).toEqual 3
#         select fieldView.$("select[name=\"inverse\"]"), "featured_by_product"
#         expect(fieldView.get("content.inverse_of")).toEqual "featured_by_product"

#         fieldView = getCustomFieldView(fieldsView, "select")
#         expect(fieldView.$("ul#recipe_type-options").length).toEqual 1
#         expect(fieldView.$("ul#recipe_type-options li").length).toEqual 3
#         expect(fieldView.$("button.add-option").length).toEqual 1
#         expect(fieldView.$("input[type='text'][name='new-option']").length).toEqual 0
#         expect(fieldView.$("button.remove-option").length).toEqual 3

#         click fieldView.$("button.remove-option:first")
#         expect(fieldView.get("content.options.length")).toEqual 2
#         click fieldView.$("button.add-option")

#         waitForSync ->
#           expect(fieldView.$("input[type='text'][name='new-option']").length).toEqual 1
#           typeText("option 4").into(fieldView.$("input[type='text'][name='new-option']")).andHitEnter()
#           expect(fieldView.get("content.options.length")).toEqual 3
#           expect(formView.$("button.save").length).toEqual 1
#           click formView.$("button.save")
#           expect(formView.get("controller.update")).toHaveBeenCalled()
#           done()
