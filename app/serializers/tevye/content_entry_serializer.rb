class Tevye::ContentEntrySerializer < ActiveModel::Serializer
  attributes :id, :content_type_id, :site_id, :_label, :slug 
  attribute :_position, key: :position
  
  def slug
    @object.respond_to?(:slug) ? @object.slug : @object._slug
  end
  
  def site_id
    @object.content_type.site_id
  end

  def attributes
    dynamic_attributes = {}.tap do |attrs|
      custom_fields.each do |field|
        name, suffix = 
          case field.type
          when /belongs_to/ then [field.name.singularize, "_id"]
          when /has_many|many_to_many/ then [field.name.singularize, "_ids"]
          else [field.name, ""]
          end
        value  = @object.send("#{name}#{suffix}")
        value  = value.url if value.kind_of?(CarrierWave::Uploader::Base)
        attrs["#{name}#{suffix}".to_sym] = value
      end
    end
    super.merge(dynamic_attributes)
  end

  def custom_fields
    @object.content_type.entries_custom_fields
  end
end