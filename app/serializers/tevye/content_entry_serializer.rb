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
        name   = field.name
        suffix = 
          case field.type
          when /belongs_to/ then "_id"
          when /has_many|many_to_many/ then "_ids"
          else ""
          end
        value = @object.send("#{name}#{suffix}")
        attrs["#{name}#{suffix}".to_sym] = 
          value.kind_of?(CarrierWave::Uploader::Base) ? value.url : value
      end
    end
    super.merge(dynamic_attributes)
  end

  def custom_fields
    @object.content_type.entries_custom_fields
  end
end