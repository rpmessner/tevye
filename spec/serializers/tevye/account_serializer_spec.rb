require_relative '../../spec_helper'

describe Tevye::AccountSerializer do
  let(:site) { create_site }
  let(:admin) { site.memberships.where(role: "admin").first }

  it 'should serialize an account' do
    account    = admin.account
    serializer = Tevye::AccountSerializer.new(account)
    hash       = serializer.as_json
    hash.should == {
      account: {
        id: account.id,
        email: account.email,
        sign_in_count: account.sign_in_count,
        current_sign_in_at: account.current_sign_in_at,
        last_sign_in_at: account.last_sign_in_at,
        name: account.name
      }
    }
  end
end
