isPresent = Tevye.isPresent

module "SiteRoute",
  setup: setupPreload.andThen ->
    Ember.run Tevye, Tevye.advanceReadiness
  teardown: clearAll

asyncTest "renders nav view with theme specific options", ->
  visit("/sites/#{site_id}").then ->
    waitForRender ->
      site_controller  = lookup("controller:site")
      sites_controller = lookup("controller:sites")
      site             = site_controller.get('content')
      sites            = sites_controller.get('content')
      sites_view       = getRegisteredView('sites')
      site_view        = getRegisteredView('site')
      nav_view         = getChildViewByName(sites_view, /NavigationView/)

      equal sites_controller.get("selected"), site
      equal sites.get("length"), 1

      ok isPresent nav_view

      equal nav_view.$("a.active.site-link").length, 1
      equal nav_view.$("a.active.site-link").attr("href"), "/sites/#{site_id}"

      # equal site_controller.get("showImages"), false
      # equal nav_view.$("a.theme-assets").length, 1
      # nav_view.$("a.site-assets").simulate('click')
      # waitForRender ->
      #   equal site_controller.get("showImages"), true
      #   equal site_view.$("img").length, 1
      start()
