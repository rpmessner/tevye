require_relative '../../spec_helper'

describe Tevye::ContentTypesController do
  let(:site) { create_site }
  let(:content_type) { create_content_type }
  let(:site_attributes) { { 'site_id' => site.id } }

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
      it 'serializes a json response' do
        Tevye::Finder::ContentTypes
          .any_instance
          .expects(:all)
          .returns([content_type])
        Tevye::ContentTypeSerializer
          .any_instance
          .expects(:as_json)
        xhr :get, :index, site_attributes
        response.should be_success
      end
    end

    let(:id_params) { site_attributes.merge({ 'id' => content_type.id }) }

    context '#show' do
      it 'finds and serializes a json response' do
        Tevye::Finder::ContentTypes.any_instance.expects(:find)
          .returns(content_type)
        Tevye::ContentTypeSerializer.any_instance.expects(:as_json)
        xhr :get, :show, id_params
        response.should be_success
      end
    end

    let(:content_type_attributes) { { 'slug' => 'test-type' } }

    context '#create' do
      let(:create_params) do
        site_attributes.merge({'content_type' => content_type_attributes })
      end
      it 'successfully creates and serializes a json response' do
        Tevye::Creator::ContentTypes.any_instance.expects(:create)
          .with(content_type_attributes).returns(content_type)
        Tevye::ContentTypeSerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        response.should be_success
      end
    end

    context '#update' do
      let(:update_params) do
        id_params.merge({'content_type' => content_type_attributes })
      end
      it 'successfully finds theme to updates attributes' do
        Tevye::Finder::ContentTypes.any_instance.expects(:find)
          .returns(content_type)
        Locomotive::ContentType.any_instance.expects(:update_attributes)
          .with(content_type_attributes)
        Tevye::ContentTypeSerializer.any_instance.expects(:as_json)
        xhr :put, :update, update_params
        response.should be_success
      end
    end

    context '#destroy' do
      it 'successfully finds content type to delete' do
        Tevye::Finder::ContentTypes.any_instance.expects(:find)
          .returns(content_type)
        Locomotive::ContentType.any_instance.expects(:destroy)
        xhr :delete, :destroy, id_params
        response.should be_success
      end
    end

  end
end
