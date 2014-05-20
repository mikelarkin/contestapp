require 'spec_helper'

describe SessionsController do

  # Ensure that an Account exists
  before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account)
  end

  # This should return the minimal set of attributes required to create a valid
  # Order. As you add validations to Order, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { account_id: @account.id } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController. Be sure to keep this updated too.
  let(:valid_session) { {current_account_id: @account.id} }

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy', valid_session
      response.should be_redirect
    end
  end

end
