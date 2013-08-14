home = asset = stylesheet = assets_controller =
  code_view = assets = page = pages = sites = null
isPresent = Tevye.isPresent
isBlank   = Tevye.isBlank
setupAll = setupPreload.andThen ->
  assets = Tevye.ThemeAsset.findAll(theme_asset_options)
  pages = Tevye.Page.findAll(page_options)
  sites = Tevye.Site.findAll()
  Ember.run Tevye, Tevye.advanceReadiness

teardownAll = ->
  code_view.destroy()
  home = asset = stylesheet = assets_controller =
    code_view = assets = page = pages = sites = null
  clearAll()

module "CodeView with a theme asset",
  setup: setupAll.andThen ->
    waitForSync ->
      stylesheet = assets.find (x) -> x.get('id') is stylesheet_id
      assets_controller = Tevye.ThemeAssetsController.create(content: assets)
      assets_controller.setProperties
        selectedJavascript: assets_controller.get('javascripts.firstObject')
        selectedStylesheet: assets_controller.get('stylesheets.firstObject')
      sinon.spy assets_controller, 'createItem'
      sinon.spy assets_controller, 'destroyItem'
      code_view = Tevye.CodeView.create
        assetsBinding: "controller.stylesheets"
        selectedAssetBinding: "controller.selectedStylesheet"
        valueBinding: "controller.selectedStylesheet.originalSource"
        modeBinding: "controller.selectedStylesheet.sourceExt"
        controller: assets_controller
  teardown: teardownAll

asyncTest "renders", ->
  waitForRender ->
    Ember.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      id = code_view.$().attr("id")
      equal $("#" + id).length, 1
      start()

asyncTest "renders a codemirror with the asset source", ->
  waitForRender ->
    Ember.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      mirror = code_view.get("mirror")
      ok isPresent mirror
      equal code_view.get("value"), stylesheet.get("originalSource")
      equal mirror.doc.getValue(), stylesheet.get("originalSource")
      start()

asyncTest "updates the asset on save", ->
  waitForRender ->
    Em.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      mirror = code_view.get("mirror")
      evt =
        type: "keydown"
        keyCode: 83 # S
        metaKey: true
      mirror.doc.setValue "h1 { color: blue; }"
      mirror.triggerOnKeyDown evt
      waitForSync ->
        equal stylesheet.get("originalSource"), mirror.doc.getValue()
        start()

asyncTest 'removes the asset on destroy', ->
  waitForRender ->
    Em.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      code_view.$('button.destroy').simulate 'click'
      ok assets_controller.destroyItem.calledOnce
      start()

asyncTest 'creates new asset', ->
  waitForRender ->
    Em.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      filename = 'page-asset.js'

      code_view.$('button.new').simulate 'click'
      typeText(filename).into(code_view.$('input')).andHitEnter()

      ok assets_controller.createItem.calledOnce
      start()

asyncTest "is allowed to be created with a null asset", ->
  waitForRender ->
    Ember.run ->
      code_view.set "controller", Ember.Object.create()
      code_view.appendTo('#ember-testing')

    waitForRender ->
      ok isBlank code_view.get("value")
      start()

asyncTest "changing the view controller updates the mirror", ->
  waitForRender ->
    Ember.run ->
      code_view.set("controller.selectedStylesheet", null)
      code_view.appendTo('#ember-testing')

    waitForRender ->
      ok isBlank code_view.get("value")
      code_view.set "controller.selectedStylesheet", stylesheet
      waitForSync ->
        equal code_view.get("value"), stylesheet.get("originalSource")
        mirror = code_view.get("mirror")
        equal mirror.doc.getValue(), stylesheet.get("originalSource")
        equal mirror.doc.mode.name, stylesheet.get("sourceExt")
        start()

asyncTest "modifying the view controller updates the mirror", ->
  waitForRender ->
    Ember.run ->
      asset = Ember.Object.create()
      code_view.set "controller.selectedStylesheet", asset
      code_view.appendTo('#ember-testing')

    waitForRender ->
      ok isBlank code_view.get("value")
      asset.set "sourceExt", stylesheet.get("sourceExt")
      asset.set "originalSource", stylesheet.get("originalSource")
      waitForSync ->
        equal code_view.get("value"), stylesheet.get("originalSource")
        mirror = code_view.get("mirror")
        equal mirror.doc.getValue(), stylesheet.get("originalSource")
        equal mirror.doc.mode.name, stylesheet.get("sourceExt")
        start()

module "CodeView with a page template",
  setup: setupAll.andThen ->
    waitForSync ->
      home = Tevye.Page.find(home_id, page_options)
      code_view = Tevye.CodeView.create
        valueBinding: "controller.content.rawTemplate"
        modeBinding: "controller.mode"
        controller: Tevye.ItemController.create content: home
  teardown: teardownAll

asyncTest "displays a page template in the mirror", ->
  waitForRender ->
    Ember.run -> code_view.appendTo('#ember-testing')
    waitForRender ->
      mirror = code_view.get("mirror")
      ok isPresent mirror
      equal code_view.get("value"), home.get("rawTemplate")
      equal mirror.doc.getValue(), home.get("rawTemplate")
      start()
