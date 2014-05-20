require 'spec_helper'

describe WebhooksController do

  # This should return the minimal set of attributes required to create a valid
  # Variant. As you add validations to Variant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VariantsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

 before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account)
  end

  describe "GET 'uninstall'" do

    it "returns http success" do
        pending "book deadline"
      get 'uninstall', nil, {'HTTP_X_SHOPIFY_SHOP_DOMAIN' => @account.shopify_account_url}
      response.should be_success
    end
  end

end
