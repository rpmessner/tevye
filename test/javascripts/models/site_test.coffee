site = sites = null
isBlank      = Tevye.isBlank
merge        = Tevye.merge
setupAll     = ->
teardownAll  = -> clearAll()
mockjax      = (options) -> $.mockjax _.extend(options , ajax_options)
ajax_options =
  responseTime: 1
  contentType:  'application/json'
error_response =
  errors:
    slug: ["can't be blank"]
    name: ["can't be blank"]
mockAll = -> mockjax
  status: 200
  url: '/tevye/sites'
  type: 'GET'
  responseText: TestResponses.sites.all
mockFind = -> mockjax
  url: "/tevye/sites/#{site_id}"
  type: 'GET'
  responseText: TestResponses.sites.find
mockFindError = -> mockjax
  status: 404
  type: 'GET'
  url: "/tevye/sites/#{new_id}"
  responseText: JSON.stringify(id: 'Not Found')
mockCreate = -> mockjax
  status: 200
  url: "/tevye/sites"
  type: 'POST'
  responseText: JSON.stringify(site: merge(site_json.site, id: new_id, name: 'new_site'))
mockCreateError = -> mockjax
  status: 500
  url: "/tevye/sites"
  type: 'POST'
  responseText: JSON.stringify(error_response)
mockUpdate = -> mockjax
  url: "/tevye/sites/#{site_id}"
  type: 'PUT'
  responseText: JSON.stringify(site: merge(site_json.site, name: 'updated_name'))
mockUpdateError = -> mockjax
  status: 500
  url: "/tevye/sites/#{site_id}"
  type: 'PUT'
  responseText: JSON.stringify(error_response)
mockDestroy = -> mockjax
  status: 200
  url: "/tevye/sites/#{site_id}"
  type: 'DELETE'
  responseText: JSON.stringify(destroyed: true)
mockAssets = -> mockjax
  status: 200
  url: "/tevye/theme_assets"
  data: theme_asset_options
  type: 'GET'
  responseText: TestResponses.theme_assets.all
mockPages = -> mockjax
  status: 200
  url: "/tevye/pages"
  data: page_options
  type: 'GET'
  responseText: TestResponses.pages.all
#=====================================================================
# Begin tests
#=====================================================================
module "Site findAll from server",
  setup: setupAll.andThen(mockAll).andThen ->
    sites = Tevye.Site.findAll()
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 2
  waitForSync ->
    equal sites.get("length"), 1
    equal sites.get("content.firstObject.id"), site_id
    start()
#=====================================================================
module "Site findAll from preload",
  setup: setupAll.andThen ->
    PreloadStore.store "sites", sites_json
  teardown: teardownAll

asyncTest "can be successfull", ->
  expect 2
  $.mockjax
    url: '/tevye/sites'
    response: -> ok false, "should not call ajax"
  sites = Tevye.Site.findAll()
  waitForSync ->
    equal sites.get("length"), 1
    equal sites.get("content.firstObject.id"), site_id
    start()
#=====================================================================
module "Site find from server then find all",
  setup: setupAll.andThen(mockAll).andThen(mockFind).andThen ->
    site = Tevye.Site.find(site_id)
    sites = Tevye.Site.findAll()
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 3
  waitForSync ->
    equal sites.get("length"), 1
    equal site.get("id"), site_id
    deepEqual site.get("pageIds"), page_ids
    start()
#=====================================================================
module "Site find from cache",
  setup: setupAll.andThen(mockAll).andThen ->
    sites = Tevye.Site.findAll()
    sites.then -> site = Tevye.Site.find(site_id)
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 3
  waitForSync ->
    equal sites.get("length"), 1
    equal site.get("id"), site_id
    deepEqual site.get("pageIds"), page_ids
    start()
#=====================================================================
module "Site find from preload cache",
  setup: setupAll.andThen ->
    PreloadStore.store "sites", sites_json
    sites = Tevye.Site.findAll()
    sites.then -> site = Tevye.Site.find(site_id)
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 3
  waitForSync ->
    equal sites.get("length"), 1
    equal site.get("id"), site_id
    deepEqual site.get("pageIds"), page_ids
    start()
#=====================================================================
module "Site find with error response",
  setup: setupAll.andThen(mockFindError).andThen ->
    site = Tevye.Site.find(new_id)
  teardown: teardownAll

asyncTest "can callback to promise error", ->
  expect 1
  site.then ((model) ->
    equal false, true, "should not be success"
    start()
  ), (error) ->
    equal error.id, "Not Found"
    start()
#=====================================================================
module "Site create with id & attributes",
  setup: setupAll.andThen ->
    attributes = site_json.site
    site       = Tevye.Site.create(attributes)
  teardown: teardownAll

test "is immediately successful", ->
  expect 2
  ok isBlank(site.get("page_ids"))
  deepEqual site.get("pageIds"), page_ids

asyncTest "provides a promise", ->
  expect 1
  site.then (model) ->
    deepEqual model.get("pageIds"), page_ids
    start()
#=====================================================================
module "Site create without id",
  setup: setupAll.andThen(mockAll).andThen(mockCreate).andThen ->
    attributes = name: "new_site"
    sites = Tevye.Site.findAll()
    site  = Tevye.Site.create(attributes)
  teardown: teardownAll

asyncTest "can be successful", ->
  expect 4
  waitForSync ->
    equal sites.get("length"), 2
    equal site.get("name"), "new_site"
    equal site.get("id"), new_id
    deepEqual site.get("pageIds"), page_ids
    start()

asyncTest "provides a promise", ->
  expect 4
  site.then (model) ->
    equal sites.get("length"), 2
    equal site.get("id"), new_id
    equal site.get("name"), "new_site"
    deepEqual site.get("pageIds"), page_ids
    start()
#=====================================================================
module "Site create with error response",
  setup: setupAll.andThen(mockCreateError).andThen ->
    site = Tevye.Site.create({})
  teardown: teardownAll

asyncTest "can callback to promise error", ->
  expect 4
  site.then (model) ->
    equal false, true, "should not be successful"
    start()
  , (error) ->
    deepEqual error.errors.slug, ["can't be blank"]
    equal site.get('errors.slug'), error.errors.slug

    deepEqual error.errors.name, ["can't be blank"]
    equal site.get('errors.name'), error.errors.name
    start()
#=====================================================================
module "Site destroy",
  setup: setupAll.andThen(mockDestroy).andThen ->
    site = Tevye.Site.create(site_json.site)
  teardown: teardownAll

asyncTest "is successful", ->
  expect 2
  spy = sinon.spy(site, "destroy")
  site.destroyModel()
  waitForSync ->
    ok spy.calledOnce
    ok site.isDestroyed
    start()
#=====================================================================
module "Site update",
  setup: setupAll.andThen(mockUpdate).andThen ->
    site = Tevye.Site.create(site_json.site)
    site.update name: 'updated_name'
  teardown: teardownAll

asyncTest "is successful", ->
  expect 1
  site.then ->
    equal site.get("name"), "updated_name"
    start()
#=====================================================================
module "Site lists all assets & images",
  setup: setupAll.andThen(mockFind).andThen(mockAssets).andThen ->
    site = Tevye.Site.find(site_id)
  teardown: teardownAll

asyncTest "returns list from cache", ->
  expect 5
  Tevye.ThemeAsset.findAll theme_asset_options
  waitForSync ->
    images = site.get("images")
    assets = site.get("themeAssets")
    waitForSync ->
      ok !isBlank(assets)
      equal assets.get("length"), theme_assets_json.theme_assets.length
      ok !isBlank(images)
      equal images.get("length"), images_json.theme_assets.length
      ok assets.contains(images.get('firstObject'))
      start()
#=====================================================================
module "Site lists all pages",
  setup: setupAll.andThen(mockFind).andThen(mockPages).andThen ->
    site = Tevye.Site.find(site_id)
  teardown: teardownAll

asyncTest "returns list from cache", ->
  expect 1
  Tevye.Page.findAll page_options
  waitForSync ->
    pages = site.get("pages")
    pages.then ->
      equal pages.get("length"), page_ids.length
      start()

asyncTest "returns list from cache via promise", ->
  expect 1
  Tevye.Page.findAll page_options
  site.then (site) ->
    pages = site.get("pages")
    pages.then (pages) ->
      equal pages.get("length"), page_ids.length
      start()

asyncTest "returns list from server", ->
  expect 1
  site.then (site) ->
    pages = site.get("pages")
    waitForSync ->
      equal pages.get("length"), page_ids.length
      start()

asyncTest "returns list from server via promise", ->
  expect 1
  site.then (site) ->
    pages = site.get("pages")
    pages.then (pages) ->
      equal pages.get("length"), page_ids.length
      start()
