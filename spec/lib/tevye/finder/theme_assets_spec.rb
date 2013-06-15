require_relative '../../../spec_helper'

describe Tevye::Finder::ThemeAssets do
  let(:site) { create_site }

  let(:image) { image_file }
  let(:image_asset) { FactoryGirl.create(:theme_asset, source: image, site: site) }

  let(:stylesheet) { stylesheet_file }
  let(:stylesheet_asset) { FactoryGirl.create(:theme_asset, source: stylesheet, site: site) }
  
  let(:finder) { Tevye::Finder::ThemeAssets.new(site.id) }

  context 'given a theme id' do
    it 'should find all assets' do
      assets = [stylesheet_asset, image_asset]
      finder.all.should == assets
    end

    it 'should find by id' do
      finder.find(image_asset.id).should == image_asset
    end

    context 'from another site' do
      let(:new_site) { FactoryGirl.create('another site') }
      let(:new_site_asset) { FactoryGirl.create(:theme_asset, site: new_site, source: image) }

      before(:each) do
        [new_site_asset]
      end
      it 'should not include image_assets for other sites' do
        finder.all.should_not include(new_site_asset)
      end
      it 'return nil when find by id for another site' do
        new_site = Locomotive::Site.create(name: 'new_site')
        expect {
          finder.find(new_site_asset.id).should == nil
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
