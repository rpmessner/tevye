child = parent = page = pages = null
isBlank      = Tevye.isBlank
merge        = Tevye.merge
setupAll     = ->
teardownAll  = -> clearAll()
mockjax      = (options) -> $.mockjax _.extend(options, ajax_options)
ajax_options =
  responseTime: 1
  contentType:  'application/json'
error_response =
  errors:
    slug: ["can't be blank"]
    name: ["can't be blank"]
mockAll = -> mockjax
  status: 200
  url: '/tevye/pages'
  data: page_options
  type: 'GET'
  responseText: TestResponses.pages.all
mockHome = -> mockjax
  url: "/tevye/pages/#{home_id}"
  data: page_options
  type: 'GET'
  responseText: TestResponses.pages.home
mockChild = -> mockjax
  url: "/tevye/pages/#{child_id}"
  data: page_options
  type: 'GET'
  responseText: TestResponses.pages.child
mockFind = -> mockjax
  url: "/tevye/pages/#{page_id}"
  data: page_options
  type: 'GET'
  responseText: TestResponses.pages.find
mockUpdate = -> mockjax
  url: "/tevye/pages/#{page_id}?site_id=#{site_id}"
  data: page: site_id: site_id, title_translations: en: 'Updated Title'
  type: 'PUT'
  responseText: JSON.stringify(page: merge(page_json.page, titleTranslations: en: 'Updated Title'))
mockCreate = -> mockjax
  status: 200
  url: "/tevye/pages?site_id=#{site_id}"
  data: page: title: 'Index Page'
  type: 'POST'
  responseText: JSON.stringify(page: merge(page_json.page, id: new_id, title: en: 'Index Page'))
mockDelete = -> mockjax
  status: 200
  url: "/tevye/pages/#{page_id}?site_id=#{site_id}"
  type: 'DELETE'
  responseText: JSON.stringify(destroyed: true)
mockSite = -> mockjax
  url: "/tevye/sites/#{site_id}"
  type: 'GET'
  responseText: TestResponses.sites.find
#=====================================================================
# Begin tests
#=====================================================================
module "Page findAll for theme from server",
  setup: setupAll.andThen(mockAll).andThen ->
    pages = Tevye.Page.findAll page_options
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 2
  waitForSync ->
    equal pages.get("length"), page_ids.length
    equal pages.get("content.firstObject.id"), page_id
    start()
#=====================================================================
module "Page findAll from preload",
  setup: setupAll.andThen ->
    PreloadStore.store "pages?site_id=#{site_id}", pages_json
    pages = Tevye.Page.findAll page_options
  teardown: teardownAll

asyncTest "can be successfull", ->
  expect 2
  waitForSync ->
    equal pages.get("length"), page_ids.length
    equal pages.get("content.firstObject.id"), page_id
    start()
#=====================================================================
module "Page find from server",
  setup: setupAll.andThen(mockFind).andThen ->
    page = Tevye.Page.find page_id, page_options
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 2
  waitForSync ->
    equal page.get("id"), page_id
    equal page.get("siteId"), site_id
    start()
#=====================================================================
module "Page create with id & attributes",
  setup: setupAll
  teardown: teardownAll

test "is immediately successful", ->
  page = Tevye.Page.create(page_json.page)
  ok isBlank(page.get("site_id"))
  equal page.get("siteId"), site_id
#=====================================================================
module "Page create without id",
  setup: setupAll.andThen(mockCreate).andThen ->
    attributes = title: "Index Page"
    page = Tevye.Page.create(attributes, page_options)
  teardown: teardownAll

asyncTest "can be successful", ->
  waitForSync ->
    deepEqual page.get("title"), en: "Index Page"
    start()
#=====================================================================
module "Page destroy",
  setup: setupAll.andThen(mockDelete).andThen ->
    page = Tevye.Page.create page_json.page, page_options
  teardown: teardownAll

asyncTest "is successful", ->
  expect 2
  spy = sinon.spy(page, "destroy")
  page.destroyModel page_options
  waitForSync ->
    ok spy.calledOnce
    ok page.isDestroyed
    start()
#=====================================================================
module "Page update",
  setup: setupAll.andThen(mockUpdate).andThen ->
    page = Tevye.Page.create page_json.page, page_options
    page.then (page) ->
      page.update titleTranslations: en: "Updated Title", page_options
  teardown: teardownAll

asyncTest "is successful", ->
  expect 1
  waitForSync ->
    equal page.get("title"), "Updated Title"
    start()
#=====================================================================
module "Page can retrieve site",
  setup: setupAll.andThen(mockFind).andThen(mockSite).andThen ->
    page = Tevye.Page.find(page_id, page_options)
  teardown: teardownAll

asyncTest "returns site from cache", ->
  site = Tevye.Site.find site_id
  waitForSync ->
    belongs = page.get("site")
    deepEqual belongs.get("pageIds"), site_json.site.page_ids
    equal belongs.get("title"), site_json.site.title
    equal belongs.get("slug"), site_json.site.slug

    equal belongs.get("id"), site_id
    deepEqual belongs.get("pageIds"), site.get("pageIds")
    equal belongs.get("name"), site.get("name")
    equal belongs.get("id"), site.get("id")
    start()

asyncTest "returns site from server", ->
  page.then (page) ->
    belongs = page.get("site")
    waitForSync ->
      deepEqual belongs.get("pageIds"), site_json.site.page_ids
      equal belongs.get("name"), site_json.site.name
      equal belongs.get("id"), site_id
      start()
#=====================================================================
module "Page retrieves parent page from cache",
  setup: setupAll.andThen(mockHome).andThen(mockChild).andThen ->
    parent = Tevye.Page.find home_id, page_options
    child = Tevye.Page.find child_id, page_options
  teardown: teardownAll

asyncTest "is immediately successful", ->
  expect 6
  waitForSync ->
    equal child.get("parent.id"), home_json.page.id
    deepEqual child.get("parent.childIds"), home_json.page.child_ids
    equal child.get("parent.title"), home_json.page.title_translations.en
    equal child.get("parent.id"), parent.get("id")
    deepEqual child.get("parent.childIds"), parent.get("childIds")
    equal child.get("parent.title"), parent.get("title")
    start()
#=====================================================================
module "Page lists all child pages",
  setup: setupAll.andThen(mockAll).andThen ->
    pages = Tevye.Page.findAll page_options
    pages.then ->
      page = Tevye.Page.find home_id, page_options
  teardown: teardownAll

asyncTest "returns list from cache", ->
  waitForSync ->
    children = page.get("children")
    children.then ->
      equal children.get("length"), home_json.page.child_ids.length
      start()
