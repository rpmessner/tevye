require_relative '../../../spec_helper'

describe Tevye::Creator::ContentTypes do
  let(:site) { create_site }
  context 'given a theme id' do
    let(:creator) { Tevye::Creator::ContentTypes.new(site.id) }
    let(:content_type_attributes) do
      {
        'slug' => 'test_type',
        'name' => 'Test Type',
        'entries_custom_fields_attributes' => [
          {
            'name' => 'title',
            'label' => 'Title',
            'type' => 'string'
          }
        ]
      }
    end
    it 'should create a content type given attributes' do
      content_type = creator.create(content_type_attributes)
      content_type.entries_custom_fields.length.should == 1
      content_type.slug.should == 'test_type'
      content_type.site_id.should == site.id
      content_type.id.should be_present
      content_type.entries.should == []
    end
  end
end
