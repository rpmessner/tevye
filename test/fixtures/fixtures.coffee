window.TestResponses =
  sites:
    id: "<%= raw @site.id %>"
    all: <%= render_json :sites, [@site] %>
    find: <%= render_json :site, @site %>
  content_entries:
    <% @site.content_types.each do |type| %>
    <%= raw type.slug %>:
      id: "<%= raw type.entries.first.id %>"
      all: <%= render_json :content_entries, type.entries %>
      find: <%= render_json :content_entry, type.entries.first %>
    <% end %>
  content_types:
    id: "<%= raw @site.content_types.first.id %>"
    all: <%= render_json :content_types, @site.content_types %>
    find: <%= render_json :content_type, @site.content_types.first %>
    crew: <%= render_json :content_type, @site.content_types.where(slug: 'crew').first %>
    projects: <%= render_json :content_type, @site.content_types.where(slug: 'projects').first %>
    articles: <%= render_json :content_type, @site.content_types.where(slug: 'articles').first %>
    companies: <%= render_json :content_type, @site.content_types.where(slug: 'companies').first %>
  theme_assets:
    id: "<%= raw @site.theme_assets.first.id %>"
    all: <%= render_json :theme_assets, @site.theme_assets %>
    find: <%= render_json :theme_asset, @site.theme_assets.first %>
    javascripts:
      id: "<%= raw @site.theme_assets.where(folder: 'javascripts').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'javascripts').to_a %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'javascripts').first %>
    stylesheets:
      id: "<%= raw @site.theme_assets.where(folder: 'stylesheets').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'stylesheets').to_a %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'stylesheets').first %>
    images:
      id: "<%= raw @site.theme_assets.where(folder: 'images').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'images').to_a %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'images').first %>
  snippets:
    id: "<%= raw @site.snippets.first.id %>"
    all: <%= render_json :snippets, @site.snippets %>
    find: <%= render_json :snippet, @site.snippets.first %>
  pages:
    id: "<%= raw @site.pages.first.id %>"
    all: <%= render_json :pages, @site.pages %>
    find: <%= render_json :page, @site.pages.first %>
    home: <%= render_json :page, @site.pages.where(slug: 'home').first %>
    child: <%= render_json :page, @site.pages.where(slug: 'home').first.children.first %>
    templatized: <%= render_json :page, @site.pages.where(templatized: true).first %>

site_id             = "<%= raw @site.id %>"
site_options        = site_id: site_id
page_ids            = ["<%= raw @site.page_ids.join('","') %>"]
page_id             = _.first page_ids
home_json           = JSON.parse(TestResponses.pages.home)
child_json          = JSON.parse(TestResponses.pages.child)
templatized_json    = JSON.parse(TestResponses.pages.templatized)
projects_type_json  = JSON.parse(TestResponses.content_types.projects)
companies_type_json = JSON.parse(TestResponses.content_types.companies)
articles_type_json  = JSON.parse(TestResponses.content_types.articles)
crew_type_json      = JSON.parse(TestResponses.content_types.crew)
content_type_id     = articles_type_json.content_type.id
$.extend window,
  stylesheet_id: TestResponses.theme_assets.stylesheets.id
  javascript_id: TestResponses.theme_assets.javascripts.id
  snippet_id: TestResponses.snippets.id
  theme_asset_id: TestResponses.theme_assets.id
  page_ids: page_ids
  page_id: page_id
  index_id: "<%= raw @site.pages.where(slug: 'index').first.id %>"
  new_id: "<%= raw Moped::BSON::ObjectId.new %>"
  site_id: site_id
  home_id: home_json.page.id
  templatized_id: templatized_json.page.id
  child_id: child_json.page.id
  article_id: content_type_id
  crew_id: TestResponses.content_entries.crew.id
  content_type_id: content_type_id
  companies_type_id: companies_type_json.content_type.id
  companies_type_json: companies_type_json
  projects_type_id: projects_type_json.content_type.id
  projects_type_json: projects_type_json
  articles_type_id: articles_type_json.content_type.id
  articles_type_json: articles_type_json
  crew_type_id: crew_type_json.content_type.id
  crew_type_json: crew_type_json
  page_options: site_options
  content_type_options: site_options
  theme_asset_options: site_options
  snippet_options: site_options
  content_entry_options: _.extend(content_type_id: content_type_id, site_options)
  content_types_json: JSON.parse(TestResponses.content_types.all)
  content_entries_json: JSON.parse(TestResponses.content_entries.articles.all)
  articles_json: JSON.parse(TestResponses.content_entries.articles.all)
  projects_json: JSON.parse(TestResponses.content_entries.projects.all)
  crew_json: JSON.parse(TestResponses.content_entries.crew.all)
  images_json: JSON.parse(TestResponses.theme_assets.images.all)
  theme_assets_json: JSON.parse(TestResponses.theme_assets.all)
  stylesheets_json: JSON.parse(TestResponses.theme_assets.stylesheets.all)
  javascripts_json: JSON.parse(TestResponses.theme_assets.javascripts.all)
  stylesheet_json: JSON.parse(TestResponses.theme_assets.stylesheets.find)
  javascript_json: JSON.parse(TestResponses.theme_assets.javascripts.find)
  pages_json: JSON.parse(TestResponses.pages.all)
  page_json: JSON.parse(TestResponses.pages.find)
  home_json: home_json
  child_json: child_json
  templatized_json: templatized_json
  snippets_json: JSON.parse(TestResponses.snippets.all)
  sites_json: JSON.parse(TestResponses.sites.all)
  site_json: JSON.parse(TestResponses.sites.find)
