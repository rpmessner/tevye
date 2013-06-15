# require_relative '../../spec_helper'

# describe Tevye::PreviewsController do
#   let(:site) { create_site }
#   let(:index_attributes) { { page_id: site.pages.first.id } }

#   it 'requires login' do
#     get :show, index_attributes
#     response.should be_redirect
#   end

#   context 'logged in' do
#     login_user('admin@locomotiveapp.org')

#     it 'should preview a page' do
#       Tevye::Render::Preview.any_instance.expects(:html).returns
#       get :show, index_attributes
#       response.should be_success
#       assigns[:page].should == theme.index_page
#     end
#   end
# end
