class Tevye::SnippetsController < Tevye::ResourcesController
  resources_name :snippets
  required_params :site_id
end