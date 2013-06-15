require_relative '../../spec_helper'

describe Tevye::ThemeAssetsController do
  let(:site) { create_site }
  let(:site_attributes) { { 'site_id' => site.id } }

  let(:image) { image_file }
  let(:image_asset) { FactoryGirl.create(:theme_asset, source: image, site: site) }
  let(:stylesheets_attributes) { { 'asset_type' => 'images' } }

  let(:stylesheet) { stylesheet_file }
  let(:stylesheet_asset) { FactoryGirl.create(:theme_asset, source: stylesheet, site: site) }
  let(:stylesheets_attributes) { { 'asset_type' => 'stylesheets' } }
  
  let(:javascript) { javascript_file }
  let(:javascript_asset) { FactoryGirl.create(:theme_asset, source: javascript, site: site) }
  let(:stylesheets_attributes) { { 'asset_type' => 'javascripts' } }

  before(:each) do
    [site]
  end

  it 'requires login' do
    xhr :get, :index, site_attributes
    response.should be_client_error
  end

  context 'logged in' do
    login_user

    context '#index' do
      it 'should return json response' do
        Tevye::Finder::ThemeAssets.any_instance.expects(:all)
          .returns([stylesheet_asset, image_asset])
        xhr :get, :index, site_attributes
        response.should be_success
        assigns[:theme_assets].length.should == 2
      end
    end

    let(:id_params) { site_attributes.merge({'id' => stylesheet_asset.id}) }

    context '#show' do
      it 'should return json response' do
        Tevye::Finder::ThemeAssets.any_instance.expects(:find)
          .with(stylesheet_asset.id.to_s).returns(stylesheet_asset)
        Tevye::ThemeAssetSerializer.any_instance.expects(:as_json)
        xhr :get, :show, id_params
        response.should be_success
      end
    end

    context '#create' do
      let(:stylesheet_attributes) { { 'source' => 'stylesheet' } }
      let(:create_params) { site_attributes.merge(theme_asset: stylesheet_attributes) }
      it 'should create and return json response' do
        Tevye::Creator::ThemeAssets.any_instance.expects(:create)
          .with(stylesheet_attributes).returns(stylesheet_asset)
        Tevye::ThemeAssetSerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        response.should be_success
      end
    end

    context '#update' do
      let(:stylesheet_attributes) { { 'source' => 'stylesheet' } }
      let(:update_params) { id_params.merge(theme_asset: stylesheet_attributes) }
      it 'should find and update attributes' do
        Tevye::Finder::ThemeAssets.any_instance.expects(:find)
          .with(stylesheet_asset.id.to_s).returns(stylesheet_asset)
        Locomotive::ThemeAsset.any_instance.expects(:update_attributes)
          .with(stylesheet_attributes)
        xhr :put, :update, update_params
        response.should be_success
      end
    end
    context '#destroy' do
      it 'should find and destroy' do
        Tevye::Finder::ThemeAssets.any_instance.expects(:find)
          .with(stylesheet_asset.id.to_s).returns(stylesheet_asset)
        Locomotive::ThemeAsset.any_instance.expects(:destroy)
        xhr :delete, :destroy, id_params
        response.should be_success
      end
    end
  end
end
