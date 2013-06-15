window.TestResponses =
  site:
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
  theme_asset:
    id: "<%= raw @site.theme_assets.first.id %>"
    all: <%= render_json :theme_assets, @site.theme_assets %>
    find: <%= render_json :theme_asset, @site.theme_assets.first %>
    javascripts:
      id: "<%= raw @site.theme_assets.where(folder: 'javascripts').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'javascripts') %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'javascripts').first %>
    stylesheets:
      id: "<%= raw @site.theme_assets.where(folder: 'stylesheets').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'stylesheets') %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'stylesheets').first %>
    images:
      id: "<%= raw @site.theme_assets.where(folder: 'images').first.id %>"
      all: <%= render_json :theme_assets, @site.theme_assets.where(folder: 'images') %>
      find: <%= render_json :theme_asset, @site.theme_assets.where(folder: 'images').first %>
  snippets:
    id: "<%= raw @site.snippets.first.id %>"
    all: <%= render_json :snippets, @site.snippets %>
    find: <%= render_json :snippet, @site.snippets.first %>
  pages:
    id: "<%= raw @site.pages.first.id %>"
    all: <%= render_json :pages, @site.pages %>
    find: <%= render_json :page, @site.pages.first %>

site_id = "<%= raw @site.id %>"
site_options = site_id: site_id

$.extend window,
  stylesheet_id: TestResponses.theme_assets.stylesheets.id
  javascript_id: TestResponses.theme_assets.javascripts.id
  page_ids: ["<%= raw @site.page_ids.join('","') %>"]
  new_page_id: "<%= raw Moped::BSON::ObjectId.new %>"
  site_id: site_id
  home_id: "<%= raw @site.pages.where(slug: 'home').first.id %>"
  templatized_id: "<%= raw @site.pages.where(templatized: true).first.id %>"
  artcles_id: TestResponses.content_entries.articles.id
  crew_id: TestResponses.content_entries.crew.id
  child_id: "<%= raw @site.pages.where(slug: 'home').first.children.first.id %>"
  page_options: site_options
  content_type_options: site_options
  theme_asset_options: site_options
  snippet_options: site_options
  content_entry_options: _.merge(content_type_id: content_type_id, page_options)
  content_types_json: JSON.parse(TestResponses.content_types.all)
  content_entries_json: JSON.parse(TestResponses.content_entries.recipes.all)
  articles_json: JSON.parse(TestResponses.content_entries.articles.all)
  crew_json: JSON.parse(TestResponses.content_entries.crew.all)
  images_json: JSON.parse(TestResponses.assets.images.all)
  assets_json: JSON.parse(TestResponses.assets.all)
  stylesheets_json: JSON.parse(TestResponses.assets.stylesheets.all)
  javascripts_json: JSON.parse(TestResponses.assets.javascripts.all)
  stylesheet_json: JSON.parse(TestResponses.assets.stylesheets.find)
  javascript_json: JSON.parse(TestResponses.assets.javascripts.find)
  pages_json: JSON.parse(TestResponses.pages.all.responseText)
  page_json: JSON.parse(TestResponses.pages.find.responseText)
  sites_json: JSON.parse(TestResponses.sites.all.responseText)
  site_json: JSON.parse(TestResponses.sites.all.responseText)
