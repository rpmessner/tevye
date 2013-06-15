require_relative '../../spec_helper'

describe Tevye::MembershipSerializer do
  let(:site) { create_site }
  let(:admin) { site.memberships.where(role: "admin").first }

  it 'should serialize a membership' do
    serializer = Tevye::MembershipSerializer.new(admin)
    hash = serializer.as_json
    hash.should == {
      membership: {
        id: admin.id,
        site_id: site.id,
        role: "admin",
        account: Tevye::AccountSerializer.new(admin.account, root: false).as_json
      }
    }
  end
end
