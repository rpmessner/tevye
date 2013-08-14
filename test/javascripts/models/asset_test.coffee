themes = pages = assets = null

module "ThemeAsset find from cache",
  setup: ->
    setupPreload()
    assets = Tevye.ThemeAsset.findAll theme_asset_options
    Tevye.Page.findAll page_options
    Tevye.Site.findAll()
  teardown: clearAll

asyncTest "findAll for site", ->
  assets.then ->
    equal assets.get("length"), theme_assets_json.theme_assets.length
    start()

asyncTest "belongs to a site", ->
  assets.then ->
    stylesheet = Tevye.ThemeAsset.find stylesheet_id, theme_asset_options
    stylesheet.get("site").then (site) ->
      deepEqual site.get("title"), site_json.site.title
      start()
