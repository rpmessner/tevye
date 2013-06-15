require_relative '../../spec_helper'

describe Tevye::PagesController do
  let(:site) { create_site }
  let(:page) { site.pages.first }
  let(:child) { FactoryGirl.create(:page, parent: page, site: site) }
  let(:site_attributes) { { site_id: site.id.to_s } }

  before(:each) do
    [site, child]
  end

  it 'requires login' do
    xhr :get, :index, site_attributes
    response.should be_client_error
  end

  context 'logged in' do
    login_user

    context '#index' do
      it 'should be successful' do
        Tevye::Finder::Pages.any_instance.expects(:all).returns([page])
        Tevye::PageSerializer.any_instance.expects(:as_json)
        xhr :get, :index, site_attributes
        assigns[:pages].should == [page]
        response.should be_success
      end
    end

    let(:id_params) { site_attributes.merge({'id' => child.id }) }

    context '#show' do
      it 'should be successful' do
        Tevye::Finder::Pages.any_instance.expects(:find).returns(child)
        Tevye::PageSerializer.any_instance.expects(:as_json)
        xhr :get, :show, id_params
        assigns[:page].should == child
        response.should be_success
      end
    end

    let(:page_attributes) do
      {
        'slug' => 'test_page',
        'title' => 'Test Page',
        'raw_template' => '<h1>Hello</h1>',
        'site_id' => page.site_id.to_s,
        'parent_id' => page.id.to_s
      }
    end

    context '#create' do
      let(:create_params) do
        site_attributes.merge({'page' => page_attributes})
      end
      it 'should be successful' do
        Tevye::Creator::Pages.any_instance.expects(:create)
          .with(page_attributes).returns(child)
        Tevye::PageSerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        assigns[:page].should == child
        response.should be_success
      end
    end

    context '#update' do
      let(:update_params) do
        id_params.merge({'page' => page_attributes})
      end
      it 'should be successful' do
        Tevye::Finder::Pages.any_instance.expects(:find).returns(child)
        Tevye::PageSerializer.any_instance.expects(:as_json)
        xhr :put, :update, update_params
        assigns[:page].should == child
        response.should be_success
      end
      it 'should fail when template will not compile' do
        error_attrs = id_params.merge({'page' => { raw_template: <<-EOF }})
{% if %}
EOF
        xhr :put, :update, error_attrs
        assigns[:page].should == child
        response.should be_client_error
        response_json = MultiJson.load(response.body)
        response_json["errors"]["template"].should ==
          ["Liquid Syntax error ('Syntax Error in tag 'if' - Valid syntax: if [expression]' on 'index')"]
      end
    end

    context '#delete' do
      it 'should be successful' do
        Tevye::Finder::Pages.any_instance.expects(:find).returns(child)
        Locomotive::Page.any_instance.expects(:destroy)
        xhr :delete, :destroy, id_params
        assigns[:page].should == child
        response.should be_success
      end
    end
  end
end
