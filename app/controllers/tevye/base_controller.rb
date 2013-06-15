class Tevye::BaseController < ApplicationController
  before_filter :require_account

  def admin?
    current_locomotive_account.admin?
  end

  def require_account
    authenticate_locomotive_account!
  end
end