require_relative '../../spec_helper'

describe Tevye::ThemeAssetSerializer do
  let(:site) { create_site }
  let(:stylesheet) { stylesheet_file }
  let(:image) { image_file }
  let(:theme_asset) { FactoryGirl.create(:theme_asset, source: stylesheet, site: site) }
  let(:image_asset) { FactoryGirl.create(:theme_asset, source: image, site: site) }

  let(:expected_image_result) {
    {
      theme_asset: {
        id:      image_asset.id,
        site_id: image_asset.site_id,
        folder:  'images',
        url:     image_asset.source.url,
        source_filename: image_asset.source.filename
      }
    }
  }

  let(:expected_script_result) {
    {
      theme_asset: {
        id: theme_asset.id,
        original_source: theme_asset.source.file.read,
        site_id: theme_asset.site_id,
        folder: 'stylesheets',
        source_filename: theme_asset.source.filename,
        url: theme_asset.source.url
      }
    }
  }

  it 'should serialize a script theme asset' do
    serializer  = Tevye::ThemeAssetSerializer.new(theme_asset, {})
    hash        = serializer.as_json
    hash.should == expected_script_result
  end

  it 'should serialize an image theme asset' do
    serializer  = Tevye::ThemeAssetSerializer.new(image_asset, {})
    hash        = serializer.as_json
    hash.should == expected_image_result
  end
end
