class Tevye::PageSerializer < ActiveModel::Serializer
  attributes :id, :parent_id, :site_id, :depth, :child_ids,
             :content_type_id, :raw_template_translations,
             :title_translations, :slug_translations, :fullpath

  def include_content_type_id?
    !content_type_id.nil?
  end

  def content_type_id
    @object.content_type.nil? ? nil : @object.content_type.id
  end

end
