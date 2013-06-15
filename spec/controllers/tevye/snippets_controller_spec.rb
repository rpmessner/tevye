require_relative '../../spec_helper'

describe Tevye::SnippetsController do
  let(:site) { create_site }
  let(:snippet) { FactoryGirl.create(:snippet, site: site) }
  let(:site_attributes) { { site_id: site.id.to_s } }

  before(:each) do
    [site, snippet]
  end

  it 'requires login' do
    xhr :get, :index, site_attributes
    response.should be_client_error
  end

  context 'logged in' do
    login_user

    context '#index' do
      it 'should be successful' do
        Tevye::Finder::Snippets.any_instance.expects(:all).returns([snippet])
        Tevye::SnippetSerializer.any_instance.expects(:as_json)
        xhr :get, :index, site_attributes
        assigns[:snippets].should == [snippet]
        response.should be_success
      end
    end

    let(:id_params) { site_attributes.merge({'id' => snippet.id }) }

    context '#show' do
      it 'should be successful' do
        Tevye::Finder::Snippets.any_instance.expects(:find).returns(snippet)
        Tevye::SnippetSerializer.any_instance.expects(:as_json)
        xhr :get, :show, id_params
        assigns[:snippet].should == snippet
        response.should be_success
      end
    end

    let(:snippet_attributes) do
      {
        'slug' => 'test_snippet',
        'name' => 'Test Snippet',
        'template' => '<h1>Hello</h1>'
      }
    end

    context '#create' do
      let(:create_params) do
        site_attributes.merge({'snippet' => snippet_attributes})
      end
      it 'should be successful' do
        Tevye::Creator::Snippets.any_instance.expects(:create)
          .with(snippet_attributes).returns(snippet)
        Tevye::SnippetSerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        assigns[:snippet].should == snippet
        response.should be_success
      end
    end

    context '#update' do
      let(:update_params) do
        id_params.merge({'snippet' => snippet_attributes})
      end
      it 'should be successful' do
        Tevye::Finder::Snippets.any_instance.expects(:find).returns(snippet)
        Tevye::SnippetSerializer.any_instance.expects(:as_json)
        xhr :put, :update, update_params
        assigns[:snippet].should == snippet
        response.should be_success
      end
    end

    context '#delete' do
      it 'should be successful' do
        Tevye::Finder::Snippets.any_instance.expects(:find).returns(snippet)
        Locomotive::Snippet.any_instance.expects(:destroy)
        xhr :delete, :destroy, id_params
        assigns[:snippet].should == snippet
        response.should be_success
      end
    end
  end
end
