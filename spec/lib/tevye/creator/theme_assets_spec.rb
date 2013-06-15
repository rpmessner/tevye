require_relative '../../../spec_helper'

describe Tevye::Creator::ThemeAssets do
  let(:site) { create_site }
  let(:image) { image_file }
  let(:creator) { Tevye::Creator::ThemeAssets.new(site.id) }

  context 'given a site id' do
    
    it 'should create a site asset given file' do
      theme_asset = creator.create(source: image)
      theme_asset.id.should be_present
      theme_asset.folder.should == 'images'
      theme_asset.site_id.should == site.id
    end

    it 'should create a site asset and file given filename' do
      theme_asset = creator.create(name: 'application.css')
      theme_asset.id.should be_present
      
      theme_asset.folder.should == 'stylesheets'
      theme_asset.site_id.should == site.id

      theme_asset = creator.create(name: 'application.js')
      theme_asset.folder.should == 'javascripts'
    end
  end
end
