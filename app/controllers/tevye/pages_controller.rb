class Tevye::PagesController < Tevye::ResourcesController
  resources_name :pages
  required_params :site_id
end
