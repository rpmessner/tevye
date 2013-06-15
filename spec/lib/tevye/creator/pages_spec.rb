require_relative '../../../spec_helper'

describe Tevye::Creator::Pages do
  let(:site) { create_site }
  context 'given a theme slug' do
    let(:creator) { Tevye::Creator::Pages.new(site.id) }
    let(:page_attributes) do
      {
        'slug' => 'test_page',
        'title' => 'Test Page',
        'raw_template' => '<h1>Hello</h1>',
      }
    end
    it 'should create a content type given attributes' do
      page = creator.create(page_attributes)
      page.slug.should == 'test-page'
      page.site_id.should == site.id
      page.id.should be_present
    end
  end
end
