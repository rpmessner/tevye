require_relative '../../spec_helper'

describe Tevye::ThemeAssetSerializer do
  let(:site) { create_site }
  let(:js_asset) { FactoryGirl.create(:theme_asset, source: javascript_file, site: site) }
  let(:css_asset) { FactoryGirl.create(:theme_asset, source: stylesheet_file, site: site) }
  let(:image_asset) { FactoryGirl.create(:theme_asset, source: image_file, site: site) }

  let(:expected_image_result) {
    {
      theme_asset: {
        id: image_asset.id,
        site_id: image_asset.site_id,
        folder: 'images',
        url: image_asset.source.url,
        source_filename: image_asset.source.filename,
        mode: 'image',
        source_ext: 'png'
      }
    }
  }

  let(:expected_js_result) {
    {
      theme_asset: {
        id: js_asset.id,
        original_source: js_asset.source.file.read,
        site_id: js_asset.site_id,
        folder: 'javascripts',
        source_filename: js_asset.source.filename,
        source_ext: 'js',
        mode: 'javascript',
        url: js_asset.source.url
      }
    }
  }

  let(:expected_css_result) {
    {
      theme_asset: {
        id: css_asset.id,
        original_source: css_asset.source.file.read,
        site_id: css_asset.site_id,
        folder: 'stylesheets',
        source_filename: css_asset.source.filename,
        source_ext: 'css',
        mode: 'css',
        url: css_asset.source.url
      }
    }
  }

  it 'should serialize a css theme asset' do
    serializer  = Tevye::ThemeAssetSerializer.new(css_asset, {})
    hash        = serializer.as_json
    hash.should == expected_css_result
  end

  it 'should serialize an image theme asset' do
    serializer  = Tevye::ThemeAssetSerializer.new(image_asset, {})
    hash        = serializer.as_json
    hash.should == expected_image_result
  end

  it 'should serialize an javascript theme asset' do
    serializer  = Tevye::ThemeAssetSerializer.new(js_asset, {})
    hash        = serializer.as_json
    hash.should == expected_js_result
  end
end
