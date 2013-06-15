class Tevye::AccountSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :sign_in_count,
             :current_sign_in_at, :last_sign_in_at
end
