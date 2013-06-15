require_relative '../../../spec_helper'

describe Tevye::Creator::Sites do
  let(:creator) { Tevye::Creator::Sites.new }
  let(:site_attributes) { { name: 'site_name', subdomain: 'testing-1-2-3' } }

  it 'should create a site' do
    site = creator.create(site_attributes)
    site.id.should be_present
  end
end
