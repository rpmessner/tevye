controller = type = types = form_view = null
isPresent = Tevye.isPresent
isBlank = Tevye.isBlank
getCustomFieldView = (formView, fieldType) ->
  formView.get("childViews").find (x) ->
    x.get("content.type") is fieldType

setupAll = setupPreload.andThen ->
  Ember.run Tevye, Tevye.advanceReadiness
  types = Tevye.ContentType.findAll content_type_options
  waitForSync ->
    type = types.objectAt(3)
    controller = Em.ObjectController.create
      locale: 'en'
      update: ->
      addCustomField: ->
      removeCustomField: ->
      content: type
    sinon.spy controller, "update"
    sinon.spy controller, "addCustomField"
    sinon.spy controller, "removeCustomField"
    form_view = Tevye.ContentTypeFormView.create(controller: controller)
    form_view.appendTo('#ember-testing')

teardownAll = clearAll.compose -> form_view.destroy()

module "ContentTypeFormView",
  setup: setupAll
  teardown: teardownAll

asyncTest "should render", ->
  waitForRender ->
    ok isPresent form_view.$()
    start()

asyncTest "should be able to be created", ->
  waitForRender ->
    fields_view = form_view.get("childViews.firstObject")
    equal fields_view.get("childViews.length"), 11

    types = Tevye.ContentType.fieldTypes
    ok Tevye.Sortable.detect(fields_view)
    start()

asyncTest "should allow creating new custom fields", ->
  waitForRender ->
    form_view.$('button.new').simulate('click')
    select(form_view.$('select[name="new-custom-field-type"]'), 'string')
    typeText("Text Field")
      .into(form_view.$('input[name="new-custom-field-name"]'))
      .andHitEnter()
    ok form_view.get("controller.addCustomField").calledWith
      title: 'Text Field'
      field_type: 'string'
    start()

asyncTest "should allow removing existing custom fields", ->
  waitForRender ->
    fields_view = form_view.get("childViews.firstObject")

    field_view = getCustomFieldView(fields_view, "string")
    equal field_view.$('button.destroy').length, 0

    field_view = getCustomFieldView(fields_view, "text")
    equal field_view.$('button.destroy').length, 1

    field_view.$('button.destroy').simulate('click')
    ok form_view.get('controller.removeCustomField')
      .calledWith(field_view.get('content'))

    start()

asyncTest "should render the correct input ui", ->
  waitForRender ->
    fields_view = form_view.get("childViews.firstObject")
    view = fields_view.get("childViews.firstObject")

    equal view.$("input[type='text'][name='label']").val(), view.get("customField.label")

    typeText("new-label").into view.$("input[type='text'][name='label']")
    equal view.get("content.label"), "new-label"
    equal view.$("input[type='checkbox']").length, 1

    view.$("input[type='checkbox']").simulate('click')
    ok !view.get("content.required")
    view.$("input[type='checkbox']").simulate('click')
    ok view.get("content.required")

    field_view = getCustomFieldView(fields_view, "text")
    equal field_view.$("select[name='format']").length, 1
    equal field_view.$("select[name='format']").val(), field_view.get("content.format")

    select field_view.$("select[name='format']"), "html"
    equal field_view.get("content.format"), "html"
    equal field_view.$("option").length, 2

    field_view = getCustomFieldView(fields_view, "belongs_to")
    equal field_view.$("select[name='target_type_id']").length, 1
    equal field_view.$("select[name='target_type_id'] option").length, 8

    select field_view.$("select[name='target_type_id']"), articles_type_id
    equal field_view.get("content.target_type_id"), articles_type_id

    equal field_view.$("select[name='inverse_of']").length, 1
    equal field_view.$("select[name='inverse_of'] option").length, 2

    select field_view.$("select[name='inverse_of']"), "shoutouts"
    equal field_view.get("content.inverse_of"), "shoutouts"

    field_view = getCustomFieldView(fields_view, "has_many")
    equal field_view.$("select[name='target_type_id']").length, 1
    equal field_view.$("select[name='target_type_id'] option").length, 8

    select field_view.$("select[name='target_type_id']"), articles_type_id
    equal field_view.get("content.target_type_id"), articles_type_id
    equal field_view.$("select[name='inverse_of']").length, 1
    equal field_view.$("select[name='inverse_of'] option").length, 2

    select field_view.$("select[name='inverse_of']"), "author"
    equal field_view.get("content.inverse_of"), "author"

    field_view = getCustomFieldView(fields_view, "many_to_many")
    equal field_view.$("select[name='target_type_id']").length, 1
    equal field_view.$("select[name='target_type_id'] option").length, 8

    select field_view.$("select[name='target_type_id']"), articles_type_id
    equal field_view.get("content.target_type_id"), articles_type_id
    equal field_view.$("select[name='inverse_of']").length, 1
    equal field_view.$("select[name='inverse_of'] option").length, 3

    select field_view.$("select[name='inverse_of']"), "related_to_articles"
    equal field_view.get("content.inverse_of"), "related_to_articles"

    select field_view.$("select[name='inverse_of']"), "related_articles"
    equal field_view.get("content.inverse_of"), "related_articles"

    field_view = getCustomFieldView(fields_view, "select")
    equal field_view.$("ul#quality-options").length, 1
    equal field_view.$("ul#quality-options li").length, 3
    equal field_view.$("button.add-option").length, 1
    equal field_view.$("input[type='text'][name='new-option']").length, 0
    equal field_view.$("button.remove-option").length, 3

    field_view.$("button.remove-option:first").simulate("click")
    equal _.size(field_view.get("content.select_options")), 3

    field_view.$("button.add-option").simulate("click")
    waitForSync ->
      equal field_view.$("input[type='text'][name='new-option']").length, 1
      typeText("option 4")
        .into(field_view.$("input[type='text'][name='new-option']"))
        .andHitEnter()

      equal field_view.get("content.select_options.length"), 4
      equal form_view.$("button.save").length, 1

      form_view.$("button.save").simulate('click')
      ok form_view.get("controller.update").calledOnce

      start()
