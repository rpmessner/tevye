Tevye.Router.map ->
  @resource "sites", ->
    @resource "site", path: ":site_id", ->
      @resource "pages", ->
        @resource "page", path: ":page_id"
      @resource "themeAssets", ->
        @resource "themeAsset", path: ":theme_asset_id"
      @resource "contentTypes", path: "content_types", ->
        @resource "contentType", path: ":content_type_id", ->
          @resource "contentEntries", path: "content_entries", ->
            @resource "contentEntry", path: ":content_entry_id"
