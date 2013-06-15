class Tevye::ThemeAssetsController < Tevye::ResourcesController
  resources_name :theme_assets
  required_params :site_id
end
