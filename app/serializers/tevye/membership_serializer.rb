class Tevye::MembershipSerializer < ActiveModel::Serializer
  attributes :id, :site_id, :account, :role, :account

  def account
    Tevye::AccountSerializer.new(@object.account, root: false).as_json
  end

  def site_id
    @object.site.id
  end

end
