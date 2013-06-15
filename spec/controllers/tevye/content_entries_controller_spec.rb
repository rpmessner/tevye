require_relative '../../spec_helper'

describe Tevye::ContentEntriesController do
  let(:site) { create_site }

  let(:content_type) { create_content_type }
  let(:content_entry) { content_type.entries.create(slug: 'hi', string_field: 'Hi') }
  let(:site_attributes) { { site_id: content_type.site.id } }
  let(:content_type_attributes) { site_attributes.merge({ content_type_id: content_type.id }) }
  let(:content_entry_attributes) { content_type_attributes.merge(id_params) }
  let(:id_params) { { id: content_entry.id } }

  before(:each) do
    [site]
  end

  it 'requires login' do
    xhr :get, :index, content_type_attributes
    response.should be_client_error
  end

  context 'logged in' do
    login_user

    context '#index' do
      it 'should be successful' do
        Tevye::Finder::ContentEntries.any_instance.expects(:all)
          .returns([content_entry])
        Tevye::ContentEntrySerializer.any_instance.expects(:as_json)
        xhr :get, :index, content_type_attributes
        assigns[:content_entries].should == [content_entry]
        response.should be_success
      end
    end

    context '#show' do
      it 'should be successful' do
        Tevye::Finder::ContentEntries.any_instance.expects(:find)
          .returns(content_entry)
        Tevye::ContentEntrySerializer.any_instance.expects(:as_json)
        xhr :get, :show, content_entry_attributes
        assigns[:content_entry].should == content_entry
        response.should be_success
      end
    end

    let(:entry_attributes) { { 'slug' => 'entry', 'string_field' => 'Entry' } }

    context '#create' do
      let(:create_params) do
        content_type_attributes.merge({'content_entry' => entry_attributes})
      end
      it 'should be successful' do
        Tevye::Creator::ContentEntries.any_instance.expects(:create)
          .with(entry_attributes).returns(content_entry)
        Tevye::ContentEntrySerializer.any_instance.expects(:as_json)
        xhr :post, :create, create_params
        assigns[:content_entry].should == content_entry
        response.should be_success
      end
    end

    context '#update' do
      let(:update_params) do
        content_entry_attributes.merge({'content_entry' => entry_attributes })
      end
      it 'should be successful' do
        Tevye::Finder::ContentEntries.any_instance.expects(:find)
          .returns(content_entry)
        content_entry.class.any_instance.expects(:update_attributes)
          .with(entry_attributes)
        Tevye::ContentEntrySerializer.any_instance.expects(:as_json)
        xhr :put, :update, update_params
        assigns[:content_entry].should == content_entry
        response.should be_success
      end
    end

    context '#destroy' do
      it 'should be successful' do
        Tevye::Finder::ContentEntries.any_instance.expects(:find)
          .returns(content_entry)
        content_entry.class.any_instance.expects(:destroy)
        xhr :delete, :destroy, content_entry_attributes
        assigns[:content_entry].should == content_entry
        response.should be_success
      end
    end
  end
end
