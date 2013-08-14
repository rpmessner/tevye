isBlank    = Tevye.isBlank
isPresent  = Tevye.isPresent
isEmpty    = Ember.isEmpty
merge      = Tevye.merge

nullErrors = (errorKey) ->
  -> @set(errorKey, [])

setErrors  = (errorKey) ->
  (error) ->
    errors = parseErrors(error)
    @set(errorKey, errors)

hasContent = ->
  (->
    isPresent @get('content')
  ).property('content')

Tevye.CollectionController = Em.Controller.extend
  plural: true
  selected: null
  hasContent: hasContent()
  createItem: (attributes) -> console.log 'create'
  destroyItem: (id) -> console.log 'destroy'

Tevye.ItemController = Em.Controller.extend
  plural: false
  errors: []
  hasContent: hasContent()
  update: (attrs) ->
    @get('content').update(attrs, @get('options'))
      .then $.proxy(nullErrors('errors'), @), $.proxy(setErrors('errors'), @)

Tevye.ApplicationController = Em.Controller.extend()
  # resizeHeight: null
  # resizeWidth: null

Tevye.SitesController = Tevye.CollectionController.extend
  resourceName: 'site'
  needs: ['site']
  createItem: (args) -> Tevye.Site.create(args)

Tevye.SiteController = Tevye.ItemController.extend
  resourceName: 'site'
  showImages: false
  needs: ['pages','themeAssets','contentTypes','contentEntries']

Tevye.ContentTypeController = Tevye.ItemController.extend
  resourceName: 'content-type'
  addCustomField: (attrs) ->
    customFieldAttrs = @get('content.customFields').map (x) ->
      id: x.get('id')
    customFieldAttrs.unshift attrs
    @updateCustomFields(customFieldAttrs)
  removeCustomField: (field) ->
    customFieldAttrs = @get('content.customFields')
      .filterProperty('id', field.get('id'))
      .map((x) -> id: x.get('id'), _destroy: true)
    @updateCustomFields(customFieldAttrs)
  updateCustomFields: (attrs) ->
    customFieldAttrs = customFieldsAttributes: attrs
    options = theme_id: @get('content.themeId')
    @get('content').update(customFieldAttrs, options)
  update: -> debugger
  options: (->
    theme_id: @get('content.themeId')
  ).property('content.themeId')

Tevye.ContentTypeIndexController = Tevye.ContentTypeController.extend
  resourceName: 'content-type'
  needs: ['contentType']

Tevye.ContentEntriesController = Tevye.CollectionController.extend
  resourceName: 'content-entry'

Tevye.ContentEntryController = Tevye.ItemController.extend
  resourceName: 'content-entry'
  options: (->
    content_type_id: @get('content.contentTypeId')
    theme_id: @get('content.themeId')
  ).property('content.themeId', 'content.contentTypeId')

Tevye.ContentTypesController = Tevye.CollectionController.extend
  resourceName: 'content-type'
  needs: ['site', 'contentEntries']
  createItem: (args) ->
    siteId = @get('controllers.site.content.id')
    contentType = Tevye.ContentType.create(args, site_id: siteId)
    contentType.then (type) =>
      @get('content').addObject(type)
      ids = @get("controllers.site.content.contentTypeIds")
      ids.addObject type.get('id')
  selectedObserver: (->
    entriesController = @get('controllers.contentEntries')
    selected = @get('selected')
    if not isBlank(selected) and not window.location.hash.match(/content_entries/)
      entriesController.set('content', selected.get('entries'))
  ).observes('selected')

Tevye.PagesController = Tevye.CollectionController.extend
  needs: ['site']
  resourceName: 'page'
  reparent: (child, parent) ->
    themeId    = @get('controllers.site.content.id')
    options    = theme_id: themeId
    oldParent  = Tevye.Page.find(child.get('parentId'), options)
    modelKlass = child.constructor
    child.update(parentId: parent.get('id'), options)
    child.then ->
      modelKlass.fetch(oldParent.get('id'), options)
      modelKlass.fetch(parent.get('id'), options)
  rootPages: (->
    (@get('content') or []).filter (item) ->
      isBlank(item.get('parentId'))
  ).property('content.@each')
  createItem: (args) ->
    parent  = @get('selected.id')
    args    = merge(args, parent_id: parent)
    siteId = @get('controllers.site.content.id')
    page    = Tevye.Page.create(args, site_id: siteId)
    page.then (p) =>
      childIds = @get('selected.childIds')
      childIds.addObject(p.get('id'))

Tevye.PageController = Tevye.ItemController.extend
  resourceName: 'page'
  needs: ['application', 'themeAssets']
  mode: 'htmlmixed'
  options: (->
    site_id: @get('content.siteId')
  ).property('content.siteId')

Tevye.ThemeAssetsController = Tevye.CollectionController.extend
  resourceName: 'theme-asset'
  selectedStylesheet: null
  stylesheets: (->
    content = @get('content') || []
    content.filterProperty('folder', 'stylesheets')
  ).property('content.@each')
  stylesheetsObserver: (->
    if isBlank @get('selectedStylesheet')
      @set 'selectedStylesheet', @get('stylesheets.firstObject')
  ).observes('stylesheets.@each')
  selectedJavascript: null
  javascripts: (->
    content = @get('content') || []
    content.filterProperty('folder', 'javascripts')
  ).property('content.@each')
  javascriptsObserver: (->
    if isBlank @get('selectedJavascript')
      @set 'selectedJavascript', @get('javascripts.firstObject')
  ).observes('javascripts.@each')
  images: (->
    @get('content').filterPropety('folder', 'images')
  ).property('content.@each')
  fonts: (->
    @get('content').filterProperty('folder', 'fonts')
  ).property('content.@each')
  updateAsset: (asset, attrs) ->
    key     = "selected#{asset.get('mode').capitalize()}.errors"
    success = $.proxy(nullErrors(key), @)
    error   = $.proxy(setErrors(key), @)
    asset
      .update(attrs, site_id: asset.get('siteId'))
      .then(success, error)
