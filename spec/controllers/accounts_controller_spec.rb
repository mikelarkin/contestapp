require 'spec_helper'

describe AccountsController do

  before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account, paid: false)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController. Be sure to keep this updated too.
  let(:valid_session) { {current_account_id: @account.id} }

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {}, valid_session
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "returns http success" do

      ShopifyAPI::RecurringApplicationCharge.should_receive(:create).with(:name=>"Contest App Paid Membership", price: 1.0,
                                                                 return_url: "#{DOMAIN}/shopify/confirm",
                                                                 test: true).and_return(mock("ShopifyRecurringCharge", id: 1012637313, confirmation_url: "http://test.host/account"))

      put 'update', {:account => { "paid" => true}}, valid_session
      response.should redirect_to "http://test.host/account"
    end
  end

end
