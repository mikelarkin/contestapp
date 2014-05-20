require 'spec_helper'

describe ShopifyController do

  let(:valid_session) { {} }
  before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account)
  end

  context "authorize" do

    it "should require the shop param" do
      get :authorize, {}, valid_session
      response.body.should == ":shop parameter required"

      get :authorize, {:shop => nil}, valid_session
      response.body.should == ":shop parameter required"

      get :authorize, {:shop => ""}, valid_session
      response.body.should == ":shop parameter required"

    end

    it "should redirect to the proper OAuth url" do
      get :authorize, {:shop => "test-shop.myshopify.com"}, valid_session
      response.should redirect_to("https://test-shop.myshopify.com/admin/oauth/authorize?client_id=#{SHOPIFY_API_KEY}&scope=read_products,read_orders,read_customers")

    end

     it "should redirect to the proper OAuth url" do
      get :authorize, {:shop => "test-shop"}, valid_session
      response.should redirect_to("https://test-shop.myshopify.com/admin/oauth/authorize?client_id=#{SHOPIFY_API_KEY}&scope=read_products,read_orders,read_customers")

    end

  end

  context "install" do

    before do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:any, "https://test-shopify.myshopify.com/admin/oauth/access_token", :body => '{"access_token":"54321"}')
      FakeWeb.register_uri(:any, "https://test-shopify.myshopify.com/admin/shop.json", :body => '{"name":"test-shop", "id":"123123"}')
      FakeWeb.register_uri(:any, "https://test-shopify.myshopify.com/admin/webhooks.json", :body => '{"name":"test-shop", "id":"123123"}')

      @shop_response = OpenStruct.new(name: "Test Shop", id: 1231231, domain: "test-shop.com", shop_owner: "Daffy Duck",
                                      email: "daffy@duck.com", address1: "123 Duck Road", city: "Duckville",
                                      province_code: "AL", province: "Alabama", country: "United States", zip: "12345",
                                      phone: "555-555-1234", plan_name: "enterprise", timezone: "EST")

    end

    it "should verify the request" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      get :install, {:shop => "test-shopify.myshopify.com", :code => "1234"}, valid_session
    end

    it "should render a message and return if verification fails" do

      ShopifyIntegration.should_receive(:verify).and_return(false)

      get :install, {:shop => "test-shopify.myshopify.com", :code => "1234"}, valid_session
      response.body.should == "Unable to verify request"
    end

    it "should create a new Account (if one doesn't exist)" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      expect {get :install, {:shop => "test-shopify.myshopify.com", :code => "1234"}, valid_session}.to change {Account.count}.by(1)
    end

    it "should update an existing account" do
      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      ShopifyIntegration.should_receive(:verify).and_return(true)
      account = FactoryGirl.create(:account, shopify_account_url: "test-shopify.myshopify.com", shopify_password: "9876")
      get :install, {:shop => "test-shopify.myshopify.com", :code => "1234"}, valid_session
      account.reload
      account.shopify_password.should == "54321"


    end


  end

end