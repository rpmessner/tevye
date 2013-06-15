require_relative '../../spec_helper'

describe Tevye::CustomFieldSerializer do
  let(:site) { create_site }
  let(:content_type) { create_content_type }

  it 'should serialize string fields' do
    field = custom_field('String Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        name: 'string_field',
        type: 'string',
        label: 'String Field',
        required: true,
        position: 0
      }
    }
  end

  it 'should serialize text fields' do
    field = custom_field('Text Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        name: 'text_field',
        type: 'text',
        label: 'Text Field',
        required: false,
        position: 1,
        text_formatting: 'html'
      }
    }
  end

  it 'should serialize date fields' do
    field = custom_field('Date Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        name: 'date_field',
        type: 'date',
        label: 'Date Field',
        required: false,
        position: 3
      }
    }
  end

  it 'should serialize boolean fields' do
    field = custom_field('Boolean Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        name: 'boolean_field',
        type: 'boolean',
        label: 'Boolean Field',
        required: false,
        position: 4
      }
    }
  end

  it 'should serialize select fields' do
    field = custom_field('Select Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        name: 'select_field',
        type: 'select',
        label: 'Select Field',
        required: false,
        position: 7,
        select_options: field.select_options.inject({}){|coll, val| coll[val.id] = val.name_translations; coll}
      }
    }
  end
  it 'should serialize has_many fields' do
    field = custom_field('Has Many Field')
    belongs_to = custom_field('Belongs To Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        required: false,
        name: 'has_many_field',
        type: 'has_many',
        label: 'Has Many Field',
        position: 8,
        target_type_id: content_type.id,
        class_name: field.class_name,
        inverse_of: 'belongs_to_field',
        ui_enabled: true,
        target_id: belongs_to.id
      }
    }
  end

  it 'should serialize belongs_to fields' do
    has_many = custom_field('Has Many Field')
    field = custom_field('Belongs To Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        type: 'belongs_to',
        name: 'belongs_to_field',
        label: 'Belongs To Field',
        class_name: field.class_name,
        target_type_id: content_type.id,
        inverse_of: 'has_many_field',
        required: false,
        position: 9,
        ui_enabled: true,
        target_id: has_many.id,
      }
    }
  end

  it 'should serialize many_to_many fields' do
    many_inverse = custom_field('Many To Many Inverse Field')
    field = custom_field('Many To Many Field')
    serializer = Tevye::CustomFieldSerializer.new(field, {})
    serializer.as_json.should == {
      custom_field: {
        id: field.id,
        required: false,
        type: 'many_to_many',
        label: 'Many To Many Field',
        position: 10,
        target_type_id: content_type.id,
        class_name: field.class_name,
        inverse_of: 'many_to_many_inverse_field',
        target_id: many_inverse.id,
        ui_enabled: true,
        name: 'many_to_many_field'
      }
    }
  end

  def custom_field(label)
    content_type.entries_custom_fields.where(label: label).first
  end
end
