require_relative '../../spec_helper'

describe Tevye::ContentEntrySerializer do
  let(:site) { create_site }
  let(:content_type) { create_content_type }
  let(:select_field) { content_type.entries_custom_fields.where(name: 'select_field').first }
  let(:select_id) { select_field.select_options.first.id }
  
  let(:content_entry_attributes) do
    {
      'slug' => 'new-entry',
      'string_field' => 'some string',
      'text_field' => 'some text',
      'select_field_id' => select_id,
      'date_field' => '2011-02-01',
      'boolean_field' => 'true',
      'float_field' => 10.3,
      'money_field' => 10.4,
      'file_field' => image_file
    }
  end

  let(:content_entry_blank_attributes) do
    { 'slug' => 'new-entry',
      'string_field' => 'is required'
    }
  end

  let(:content_entry) do
    content_type.entries.create(content_entry_attributes)
  end

  let(:blank_content_entry) do
    content_type.entries.create(content_entry_blank_attributes)
  end

  it 'should serialize a content entry' do
    entry      = content_entry
    serializer = Tevye::ContentEntrySerializer.new(entry, {})
    hash       = serializer.as_json
    hash.should == {
      content_entry: {
        id: entry.id,
        content_type_id: entry.content_type_id,
        site_id: entry.content_type.site_id,
        _label: entry.string_field,
        slug: 'new-entry',
        position: 1, 
        string_field: 'some string',
        text_field: 'some text',
        file_field: entry.file_field.url,
        date_field: entry.date_field,
        boolean_field: true,
        money_field: entry.money_field,
        float_field: 10.3,
        select_field: 'one',
        has_many_field_ids: [],
        belongs_to_field_id: nil,
        many_to_many_field_ids: [],
        many_to_many_inverse_field_ids: []
      }
    }
  end
  it 'should serialize a blank content entry' do
    entry      = blank_content_entry
    serializer = Tevye::ContentEntrySerializer.new(entry, {})
    hash       = serializer.as_json
    hash.should == {
      content_entry: {
        id: entry.id,
        content_type_id: entry.content_type_id,
        site_id: entry.content_type.site_id,
        _label: 'is required',
        slug: 'new-entry',
        position: 1,
        string_field: 'is required',
        float_field: nil,
        money_field: Money.new(0),
        file_field: nil,
        text_field: nil,
        select_field: nil,
        date_field: nil,
        boolean_field: false,
        has_many_field_ids: [],
        belongs_to_field_id: nil,
        many_to_many_field_ids: [],
        many_to_many_inverse_field_ids: []
      }
    }
  end
end