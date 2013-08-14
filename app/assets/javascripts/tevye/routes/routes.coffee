isBlank = Tevye.isBlank

Tevye.ApplicationRoute = Em.Route.extend({})
  # setupController: (controller, model) ->

Tevye.IndexRoute = Em.Route.extend({})
  # redirect: ->
#     @transitionTo('sites')

Tevye.SitesRoute = Em.Route.extend
  model: -> Tevye.Site.findAll()
  setupController: (controller, model) ->
    controller.set('content', model)

Tevye.SiteRoute = Em.Route.extend
  model: (params) ->
    @modelFor('sites').find (x) ->
      x.get('id') is params.site_id

  setupController: (controller, model) ->
    sitesController        = @controllerFor('sites')
    pagesController        = @controllerFor('pages')
    assetsController       = @controllerFor('themeAssets')
    contentTypesController = @controllerFor('contentTypes')
    contentTypes           = model.get('contentTypes')
    pages                  = model.get('pages')
    sitesController.set('selected', model)
    pages.then ->
      pagesController.set('content', pages)
    contentTypes.then ->
      contentTypesController.set('content', contentTypes)

    controller.set('content', model)

    assets = model.get('themeAssets')
    assetsController.set('content', assets)

Tevye.ContentTypesRoute = Em.Route.extend
  model: ->
    site = @modelFor('site')
    site.get('contentTypes')

  setupController: (controller, model) ->
    controller.set('content', model)

Tevye.ContentTypesIndexRoute = Em.Route.extend
  setupController: (controller, model) ->
    controller.set('content', @modelFor('contentTypes'))

Tevye.ContentTypeRoute = Em.Route.extend
  model: (params) ->
    types = @modelFor('contentTypes')
    types.find (x) ->
      x.get('id') is params.content_type_id

  setupController: (controller, model) ->
    controller.set('content', model)

    typesController = @controllerFor('contentTypes')
    typesController.set('selected', model)

    entriesController = @controllerFor('contentEntries')
    if isBlank(entriesController.get('content'))
      entriesController.set('content', model.get('entries'))

Tevye.ContentEntriesIndexRoute = Em.Route.extend
  setupController: (controller, model) ->
    controller.set('content', @modelFor('contentEntries'))

Tevye.ContentEntriesRoute = Em.Route.extend
  model: (params) ->
    type = @modelFor('contentType')
    type.get('entries')

  setupController: (controller, model) ->
    controller.set('content', model)

Tevye.ContentEntryRoute = Em.Route.extend
  model: (params) ->
    entries = @modelFor('content_entries')
    entries.find (x) ->
      x.get('id') is params.content_entry_id

  setupController: (controller, model) ->
    controller.set('content', model)

Tevye.PagesRoute = Em.Route.extend
  model: (params) ->
    site = @modelFor('site')
    site.get('pages')
  setupController: (controller, model) ->
    controller.set('content', model)

Tevye.PageRoute = Em.Route.extend
  model: (params) ->
    pages = @modelFor('pages')
    pages.find (x) ->
      x.get('id') is params.page_id
  setupController: (controller, model) ->
    pagesController = @controllerFor('pages')
    pagesController.set('selected', model)
    controller.set('content', model)
