merge     = Tevye.merge
isPresent = Tevye.isPresent
isBlank   = Tevye.isBlank
getPagesListView = (router) ->
  getChildViewByName getViewByName("site"), /PagesListView/

module "PagesListView",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "should render the page list view on the theme page", ->
  visit("/sites/#{site_id}").then ->
    pages_list_view = getPagesListView()

    ok isPresent pages_list_view

    start()

asyncTest "should recieve the pages controller for the current site", ->
  visit("/sites/#{site_id}").then ->
    pages_list_view = getPagesListView()
    pages_controller = lookup("controller:pages")

    ok isPresent pages_controller
    equal pages_controller.get("content.firstObject.siteId"), site_id
    deepEqual pages_list_view.get("controller"), pages_controller

    start()

asyncTest "should render proper tags & classes for each element", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      pages_list_view = getPagesListView()

      equal pages_list_view.$("ul.nav").length, 1
      equal pages_list_view.$("ul.page-node").length, 16
      equal pages_list_view.$("li.root").length, 4
      equal pages_list_view.$("li.child").length, 12

      start()

asyncTest "open and close node", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      pages_list_view = getPagesListView()

      equal visiblePages(pages_list_view).length, 4
      equal allIcons(pages_list_view).length,     2
      equal visibleIcons(pages_list_view).length, 1
      equal hiddenIcons(pages_list_view).length,  1
      equal openIcons(pages_list_view).length,    2
      equal closeIcons(pages_list_view).length,   0

      click allIcons(pages_list_view).first()
      equal visiblePages(pages_list_view).length, 14
      equal visibleIcons(pages_list_view).length, 2
      equal hiddenIcons(pages_list_view).length,  0
      equal openIcons(pages_list_view).length,    1
      equal closeIcons(pages_list_view).length,   1

      click allIcons(pages_list_view).last()
      equal visiblePages(pages_list_view).length, 16
      equal visibleIcons(pages_list_view).length, 2
      equal hiddenIcons(pages_list_view).length,  0
      equal openIcons(pages_list_view).length,    0
      equal closeIcons(pages_list_view).length,   2

      start()

asyncTest "selecting", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      pages_list_view = getPagesListView()
      home_link = pages_list_view.$("a:nth(2)")

      equal pages_list_view.$(".active").length, 0
      equal pages_list_view.$("a").length, 16
      equal home_link.attr("href"), "/sites/#{site_id}/pages/#{home_id}"

      visit(home_link.attr('href')).then ->
        waitForRender ->
          equal lookup("controller:page").get("content.id"), home_id
          equal lookupRouter().get("url"), "/sites/#{site_id}/pages/#{home_id}"
          equal pages_list_view.$(".active").length, 1

          start()

mockCreate = -> $.mockjax
  responseTime: 1
  contentType:  'application/json'
  status: 200
  url: "/tevye/pages?site_id=#{site_id}"
  data: page: title: 'New Page'
  type: 'POST'
  responseText: JSON.stringify(page: merge(page_json.page, id: new_id, title: en: 'New Page'))
asyncTest "create button", ->
  mockCreate()
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      pages_list_view = getPagesListView()
      button = allNewButtons(pages_list_view)[0]
      text_field = allTextInputs(pages_list_view)[0]

      ok isBlank text_field
      ok isPresent button

      controller = lookup("controller:pages")
      sinon.spy controller, "createItem"

      $(button).simulate("click")
      text_field = allTextInputs(pages_list_view).first()
      ok isPresent text_field

      typeText("New Page").into(text_field).andHitEnter()
      ok controller.createItem.calledOnce
      start()
