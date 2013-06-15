require_relative '../../../spec_helper'

describe Tevye::Creator::ContentEntries do
  let(:site) { create_site }
  let(:content_type) { create_content_type }

  context 'given a site id, content type id' do
    let(:creator) { Tevye::Creator::ContentEntries.new(site.id, content_type.id) }
    let(:content_entry_attributes) do
      {
        'slug' => 'entry-slug',
        'string_field' => 'Entry Title'
      }
    end

    it 'should create a content entry given attributes' do
      entry = creator.create(content_entry_attributes)
      entry.string_field.should == 'Entry Title'
      entry.slug.should == 'entry-slug'
      entry.site_id.should == site.id
      entry.content_type_id.should == content_type.id
      entry.id.should be_present
    end
  end
end
