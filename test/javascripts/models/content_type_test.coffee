sites = content_entries = content_types = pages = assets = null

setupAll = ->
  setupPreload()
  assets          = Tevye.ThemeAsset.findAll theme_asset_options
  pages           = Tevye.Page.findAll page_options
  sites           = Tevye.Site.findAll()
  content_types   = Tevye.ContentType.findAll content_type_options
  content_entries = Tevye.ContentEntry.findAll content_entry_options

num_content_types = content_types_json.content_types.length
num_articles      = articles_json.content_entries.length
num_crew_fields   = crew_type_json.content_type.entries_custom_fields.length
teardownAll       = -> clearAll()
#=====================================================================
# Begin tests
#=====================================================================
module "ContentType", setup: setupAll, teardown: teardownAll

asyncTest "should be created", ->
  waitForSync ->
    equal content_types.get("length"), num_content_types
    start()

asyncTest "embeds many custom fields", ->
  waitForSync ->
    equal content_types.get("firstObject.entriesCustomFields.length"), num_crew_fields
    equal content_types.get("firstObject.entriesCustomFields.firstObject.type"), "string"
    equal content_types.get("firstObject.entriesCustomFields.lastObject.type"), "string"
    start()

asyncTest "belongs to a site", ->
  waitForSync ->
    recipes = Tevye.ContentType.find articles_type_id, content_type_options
    recipes.then (type) ->
      equal type.get("site.id"), sites.get("firstObject.id")
      equal type.get("site.pageIds"), sites.get("firstObject.pageIds")
      start()

asyncTest "has many entries", ->
  waitForSync ->
    recipes = Tevye.ContentType.find articles_type_id, content_type_options
    recipes.then (type) ->
      type.get("entries").then (entries) ->
        equal entries.get("firstObject.id"), content_entries.get("firstObject.id")
        equal entries.get("firstObject.title"), content_entries.get("firstObject.title")
        start()
#=====================================================================
module "ContentEntry", setup: setupAll, teardown: teardownAll

asyncTest "should be created", ->
  waitForSync ->
    equal content_entries.get("length"), num_articles
    start()

asyncTest "belongs to a theme", ->
  waitForSync ->
    equal content_entries.get("firstObject.site.id"), site_id
    start()

asyncTest "belongs to a type", ->
  waitForSync ->
    equal content_entries.get("firstObject.contentType.id"), articles_type_id
    start()
