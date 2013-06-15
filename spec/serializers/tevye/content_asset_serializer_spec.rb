require_relative '../../spec_helper'

describe Tevye::ContentAssetSerializer do
  let(:site) { create_site }
  let(:content_asset) { FactoryGirl.create(:asset, source: image_file, site: site) }

  let(:expected_image_result) {
    {
      content_asset: {
        id: content_asset.id,
        width: 32,
        height: 32,
        site_id: content_asset.site_id,
        content_type: 'image',
        source_filename: content_asset.source.filename,
        url: content_asset.source.url
      }
    }
  }

  it 'should serialize an image content asset' do
    serializer  = Tevye::ContentAssetSerializer.new(content_asset, {})
    hash        = serializer.as_json
    hash.should == expected_image_result
  end
end
