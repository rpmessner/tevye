class Tevye::PageSerializer < ActiveModel::Serializer
  attributes :id, :parent_id, :site_id, :depth,
             :title, :child_ids, :raw_template, :slug,
             :content_type_id

  def include_content_type_id?
    !content_type_id.nil?
  end

  def content_type_id
    @object.content_type.nil? ? nil : @object.content_type.id
  end

  def raw_template
    @object.raw_template_translations
  end

  def title
    @object.title_translations
  end

  def slug
    @object.slug_translations
  end
end
