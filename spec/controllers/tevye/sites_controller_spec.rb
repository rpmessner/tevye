require_relative '../../spec_helper'

describe Tevye::SitesController do
  let(:site) { create_site }
  let(:invalid_site) { FactoryGirl.build(:site, name: nil) }
  
  before(:each) do
    [site]
  end

  it 'index requires login' do
    xhr :get, :index
    response.should be_client_error
  end

  context 'logged in' do
    login_user

    context '#index' do
      it 'is successful' do
        Tevye::Finder::Sites.any_instance.expects(:all).returns([site])
        Tevye::SiteSerializer.any_instance.expects(:as_json)
        xhr :get, :index
        response.should be_success
      end
    end

    let(:id_params) { { 'id' => site.id } }

    context '#show' do
      it 'is successful' do
        Tevye::Finder::Sites.any_instance.expects(:find).returns(site)
        Tevye::SiteSerializer.any_instance.expects(:as_json)
        xhr :get, :show, id_params
        response.should be_success
      end
      it 'can error' do
        expect {
          xhr :get, :show, { 'id' => "#{site.id}677" }
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    let(:site_attributes) { { 'name' => 'test_site' } }
    let(:create_params) { { 'site' => site_attributes } }
    let(:invalid_params) { { 'site' => { } } }

    context '#create' do
      it 'is successful' do
        Tevye::Creator::Sites.any_instance.expects(:create)
          .with(site_attributes).returns(site)
        Tevye::SiteSerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        response.should be_success
      end
    end

    let(:update_params) { id_params.merge(create_params) }

    context '#update' do
      it 'is successful' do
        Tevye::Finder::Sites.any_instance.expects(:find).returns(site)
        Locomotive::Site.any_instance.expects(:update_attributes)
          .with(site_attributes)
        xhr :put, :update, update_params
        response.should be_success
      end
    end

    context'#destroy' do
      it 'should delete site' do
        Tevye::Finder::Sites.any_instance.expects(:find).returns(site)
        Locomotive::Site.any_instance.expects(:destroy)
        xhr :delete, :destroy, id_params
      end
    end
  end
end
