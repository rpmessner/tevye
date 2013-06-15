class Tevye::CustomFieldSerializer < ActiveModel::Serializer
  attributes :id, :required, :type, :label, :position,
             :text_formatting, :select_options,
             :target_type_id, :class_name, :inverse_of,
             :target_id, :name, :ui_enabled


  def inverse_of
    ret = @object.inverse_of.to_s
    ret == "" ? nil : ret
  end

  def target_type_id
    @object.class_name =~ /^Locomotive::ContentEntry(.*)/
    Moped::BSON::ObjectId.from_string $1
  end

  def target_id
    if @object.inverse_of.nil?
      nil
    else
      target_type = Locomotive::ContentType.find(target_type_id)
      found = target_type.entries_custom_fields
        .where(name: @object.inverse_of.to_s).first
      found.nil? ? nil : found.id
    end
  end

  def select_options
   @object.select_options.inject({}) do |coll, val|
      coll[val.id] = val.name_translations
      coll
    end
  end

  def include_text_formatting?
    @object.type == 'text'
  end

  def include_select_options?
    @object.type == 'select'
  end

  def include_target_id?
    %w(belongs_to has_many many_to_many).include? @object.type
  end

  alias_method :include_target_type_id?, :include_target_id?
  alias_method :include_inverse_of?, :include_target_id?
  alias_method :include_class_name?, :include_target_id?
  alias_method :include_ui_enabled?, :include_target_id?
end
