type = types = article = articles = crew = controller = form_view = null

isPresent = Tevye.isPresent

getCustomFieldView = (form_view, fieldType) ->
  form_view.get("childViews").find (x) ->
    x.get("content.type") is fieldType

module "ContentEntryFormView",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
    types = Tevye.ContentType.findAll content_type_options
    articles = Tevye.ContentEntry.findAll content_entry_options
    crew = Tevye.ContentEntry.findAll site_id: site_id, content_type_id: crew_type_id
    waitForSync ->
      type = types.get("lastObject")
      article = articles.get("firstObject")
      controller = Em.ObjectController.create
        locale: 'en'
        content: article
        update: ->
      sinon.spy controller, "update"
      form_view = Tevye.ContentEntryFormView.create(controller: controller)
      form_view.appendTo('#ember-testing')

  teardown: clearAll.compose -> form_view.destroy()

asyncTest "should create and render", ->
  waitForRender ->
    ok isPresent form_view
    ok isPresent form_view.$()
    start()

asyncTest "should render a child view for each custom field", ->
  waitForRender ->
    types = Tevye.ContentType.fieldValueTypes
    fields_view = form_view.get("childViews.firstObject")
    equal fields_view.get("childViews.length"), 11
    fields_view.get("childViews").forEach (field_view) ->
      expected_type = Em.get(types[field_view.get("content.type")])
      ok isPresent expected_type
      ok expected_type.detect(field_view.constructor)
    start()

asyncTest "should render the correct input ui", ->
  waitForRender ->
    fields_view = form_view.get("childViews.firstObject")
    fields_view.get("childViews").forEach (view) ->
      ok isPresent view.$("label").html().match(view.get("customField.label"))

    field_view = getCustomFieldView(fields_view, "file")
    equal field_view.$(".file-drop").length, 1
    # equal field_view.$("input[type='hidden']").length, 1
    # equal field_view.$("input[type='hidden']").val(), article.get("imageId")

    field_view = getCustomFieldView(fields_view, "select")
    equal field_view.$("select").length, 1
    equal field_view.$("option").length, 4
    equal null, article.get('quality')

    id = field_view.get('customField.select_options.firstObject.id')

    select field_view.$('select'), id

    equal id, article.get("quality")

    field_view = getCustomFieldView(fields_view, "boolean")
    equal field_view.$("input[type='checkbox']").length, 1
    equal field_view.$("input[type='checkbox']:checked").length, 1

    field_view = getCustomFieldView(fields_view, "text")
    equal field_view.$("textarea").length, 1
    equal field_view.$("textarea").val(), article.get("excerpt")

    field_view = getCustomFieldView(fields_view, "date")
    equal field_view.$("input[type='hidden']").length, 1
    equal field_view.$("input[type='hidden']").val(), article.get("postedAt")

    field_view = getCustomFieldView(fields_view, "string")
    equal field_view.$("input[type='text']").length, 1
    equal field_view.$("input[type='text']").val(), article.get("title")

    field_view = getCustomFieldView(fields_view, "has_many")
    equal field_view.$("ul.nav li button").length, 0
    equal article.get('shoutoutIds').length, 0
    equal field_view.$('option').length, 5

    field_view.$("button.add-has-many").simulate('click')
    waitForRender ->
      equal field_view.$("ul.nav li button").length, 1
      equal article.get('shoutoutIds').length, 1
      equal field_view.$("option").length, 4

      field_view = getCustomFieldView(fields_view, "belongs_to")
      equal field_view.$("select").val(), article.get("authorId")
      equal field_view.$("option").length, 6

      equal form_view.$("button.save").length, 1
      click form_view.$("button.save")
      ok form_view.get("controller.update").calledOnce
      start()
