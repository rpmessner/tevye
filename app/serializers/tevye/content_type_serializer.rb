class Tevye::ContentTypeSerializer < ActiveModel::Serializer
  attributes :id, :site_id, :slug, :entry_ids, :name, :order_by,
             :entries_custom_fields, :order_direction

  attribute :label_field_name, key: :label_field

  def entries_custom_fields
    @object.entries_custom_fields.map do |field|
      Tevye::CustomFieldSerializer.new(field, {}).as_json(root: false)
    end
  end

  def entry_ids
    @object.entries.map &:id
  end
end
