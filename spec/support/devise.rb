module ControllerMacros
  def login_user(email='admin@locomotiveapp.org')
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:locomotive_account]
      account = Locomotive::Account.where(email: email).first ||
      	        Locomotive::Account.create(email: email)
      sign_in account
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
end
