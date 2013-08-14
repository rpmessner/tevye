require_relative '../../spec_helper'

describe Tevye::SiteSerializer do
  let(:site) { create_site }
  let(:image) { image_file }
  let(:asset) { FactoryGirl.create(:theme_asset, source: image, site: site) }
  let(:page) { site.pages.first }
  let(:not_found) { site.pages.last }
  let(:content_type) {
    FactoryGirl.build(:content_type, site: site) do |type|
      type.entries_custom_fields.build label: 'File Field', type: 'file'
    end.tap(&:save!)
  }
  it 'should serialize the proper fields for a single model' do
    result = {
      site: {
        id: site.id,
        name: 'Locomotive test website',
        page_ids: [page.id, not_found.id],
        theme_asset_ids: [asset.id],
        content_type_ids: [content_type.id],
        site_id: site.id,
        locales: %w(en),
        default_locale: 'en'
      }
    }
    serializer = Tevye::SiteSerializer.new(site, {})
    serializer.as_json.should == result
  end

end
