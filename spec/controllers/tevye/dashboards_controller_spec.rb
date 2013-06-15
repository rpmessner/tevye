require_relative '../../spec_helper'

describe Tevye::DashboardsController do
  let(:site) { create_site }

  let(:content_type) { create_content_type }

  let(:membership) do
    site.memberships.first
  end

  before(:each) do
    [site, content_type, membership]
  end

  it 'requires login' do
    get :show
    response.should be_redirect
  end

  context 'logged in' do
    login_user

    before(:each) do
      [site, content_type, membership]
    end

    it 'should get the show' do
      get :show
      response.should be_success
    end

    it 'should preload site and content types' do
      get :show
      assigns[:preloaded].should == {
        "sites" => json('site'),
        "contentTypes" => json('content_type'),
        "memberships" => json('membership')
      }
    end
  end
end
