class Tevye::SnippetSerializer < ActiveModel::Serializer
  attributes :id, :site_id, :slug, :name, :template
 
  def template
    @object.template_translations
  end
end