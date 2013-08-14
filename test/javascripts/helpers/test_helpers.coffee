document.write """
  <div id="ember-testing-container"><div id="ember-testing"></div></div>
"""

Tevye.rootElement = '#ember-testing'
Tevye.setupForTesting()
Tevye.injectTestHelpers()

extend           = jQuery.extend
isPresent        = Tevye.isPresent
isBlank          = Tevye.isBlank
floor            = Math.floor
enter_key_code   = 13
render_wait_time = 250
sync_wait_time   = 20

jQFetcher = (selector) -> (view) -> view.$ selector

triggerEvent = (name) ->
  eventDecorators = []
  trigger = (element) ->
    event = jQuery.Event(name)
    $ele  = jQuery(element)
    eventDecorators.forEach (decorator) -> decorator event
    unless isBlank $ele[0] then $ele.trigger event
    else console.log "tried to trigger #{name} on a blank element"
    event
  extend trigger,
    wrap: (wrapper) ->
      eventDecorators.push wrapper
      trigger
  trigger

typeText = (text) ->
  changeEvent = triggerEvent('change')
  keyUpEvent = triggerEvent('keyup').wrap (event) ->
    event.keyCode = enter_key_code
  extend @,
    into: (el) =>
      @el = el
      el.val(text)
      changeEvent(el)
      @
    andHitEnter: =>
      keyUpEvent(@el)
      @
  @

select = (selectEl, value) ->
  change = triggerEvent('change')
  Ember.run ->
    selectEl.val(value)
    change selectEl

childViewPath = 'childViews.lastObject.childViews'

lookup = (key) -> Tevye.__container__.lookup(key)
lookupView = (name) -> lookup('router:main')._lookupActiveView name

$.extend window,
  select: select
  typeText: typeText
  allTextInputs: jQFetcher('input[type="text"]')
  allTextAreas: jQFetcher('textarea')
  allNewButtons: jQFetcher('button.new')
  allIcons: jQFetcher('ul i')
  editIcons: jQFetcher('i.glyphicon-edit')
  openIcons: jQFetcher('ul i.glyphicon-plus-sign')
  closeIcons: jQFetcher('ul i.glyphicon-minus-sign')
  visibleIcons: jQFetcher('ul i:visible')
  hiddenIcons: jQFetcher('i:hidden')
  allPageLinks: jQFetcher('a.page')
  allContentTypeLinks: jQFetcher('a.content-type')
  visiblePages: jQFetcher('a.page:visible')

  triggerEvent: triggerEvent
  exists: (selector) -> !!find(selector).length
  lookup: lookup
  lookupRouter: -> lookup('router:main')
  lookupView: lookupView
  lookupStore: -> lookup('store:main')
  lookupController: (name) -> lookup('controller:' + name)
  waitForSync: (func) -> setTimeout func, sync_wait_time
  waitForRender: (func) -> setTimeout func, render_wait_time
  getLastChildView: (view) -> view.get(childViewPath).last()
  getChildView: (view) -> view.get(childViewPath).first()
  getPageView: -> getRegisteredView 'page'
  getSitesView: -> getRegisteredView 'sites'
  getRegisteredView: lookupView
  getViewByName: lookupView

  getChildViewByName: (parent, name) ->
    if isPresent(parent)
      parent.get("childViews").find (view) ->
        view.toString().match name

  getChildViewsByName: (parent, name) ->
    if isPresent(parent)
      parent.get('childViews').filter (view) ->
        view.toString().match(name)

  setupPreload: ->
    PreloadStore.store("sites", sites_json)
    PreloadStore.store("theme_assets?site_id=#{site_id}", theme_assets_json)
    PreloadStore.store("snippets?site_id=#{site_id}", snippets_json)
    PreloadStore.store("content_types?site_id=#{site_id}", content_types_json)
    PreloadStore.store("content_entries?content_type_id=#{content_type_id}&site_id=#{site_id}", articles_json)
    PreloadStore.store("content_entries?content_type_id=#{crew_type_id}&site_id=#{site_id}", crew_json)
    PreloadStore.store("content_entries?content_type_id=#{projects_type_id}&site_id=#{site_id}", projects_json)
    PreloadStore.store("pages?site_id=#{site_id}", pages_json)

  clearAll: ->
    Ember.run ->
      $.mockjaxClear()
      Tevye.Model.clearCache()
      Tevye.reset()
