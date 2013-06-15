class Tevye::ContentTypesController < Tevye::ResourcesController
  resources_name :content_types
  required_params :site_id
end
