class Tevye::ContentEntriesController < Tevye::ResourcesController
  resources_name :content_entries
  required_params :site_id, :content_type_id
end
