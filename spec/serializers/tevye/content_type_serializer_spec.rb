require_relative '../../spec_helper'

describe Tevye::ContentTypeSerializer do
  let(:content_type) do
    FactoryGirl.build(:content_type, slug: 'test_type', name: 'Test Type') do |type|
      type.entries_custom_fields.build label: 'Stringy', type: 'string'
    end.tap(&:save!)
  end

  it 'should serialze a content type to json' do
    entry = content_type.entries.create(slug: 'entry', stringy: 'stringy')
    serializer = Tevye::ContentTypeSerializer.new(content_type, {})
    hash = serializer.as_json
    hash.should == {
      content_type: {
        id: content_type.id,
        site_id: content_type.site.id,
        slug: 'test_type',
        entry_ids: [entry.id],
        name: 'Test Type',
        order_by: 'created_at',
        entries_custom_fields: [
          {
            id: content_type.entries_custom_fields[0].id,
            required: true,
            type: 'string',
            name: 'stringy',
            label: 'Stringy',
            position: 0
          }
        ],
        order_direction: 'asc',
        label_field: 'stringy'
      }
    }
  end
end
