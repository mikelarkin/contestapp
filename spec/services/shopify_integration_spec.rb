require 'spec_helper'

describe ShopifyIntegration do

  before do
    # We need an Account in the system
    @account = FactoryGirl.create(:account)
  end

  context "initialize" do
    it "should raise exception if required parameters are not supplied" do
      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => "secretsecret",
                :account_id => 1
      )}.to_not raise_error

      expect {ShopifyIntegration.new(
                :password => "secretsecret"
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store"
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "",
                :password => "secretsecret"
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => nil,
                :password => "secretsecret"
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => ""
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => nil
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => "secretsecret"
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => "secretsecret",
                :account_id => ""
      )}.to raise_error

      expect {ShopifyIntegration.new(
                :url => "http://url.to.store",
                :password => "secretsecret",
                :account_id => nil
      )}.to raise_error

      expect {ShopifyIntegration.new()}.to raise_error

    end

    it "should set instance_variables" do
      shopify_integration = ShopifyIntegration.new(
        :url => "http://url.to.store",
        :password => "secretsecret",
        :account_id => 1
      )

      shopify_integration.url.should == "http://url.to.store"
      shopify_integration.password.should == "secretsecret"
      shopify_integration.account_id.should == 1

    end

  end

  context "connect" do

    before do
      @shopify_integration = ShopifyIntegration.new(
        :url => "http://url.to.store",
        :password => "secretsecret",
        :account_id => 1
      )

      @session = OpenStruct.new()
    end

    it "should activate a session with Shopify" do

      ShopifyAPI::Session.should_receive(:setup).with(:api_key => SHOPIFY_API_KEY, :secret => SHOPIFY_SHARED_SECRET)
      ShopifyAPI::Session.should_receive(:new).with("http://url.to.store", "secretsecret").and_return(@session)
      ShopifyAPI::Base.should_receive(:activate_session).with(@session)
      @shopify_integration.connect
    end

  end



  context "import_products" do
    before do

      @shopify_integration = ShopifyIntegration.new(
        :url => "http://url.to.store",
        :password => "secretsecret",
        :account_id => 1
      )

      @product1 = OpenStruct.new(:id => 1234, :name => "Another Product", :variants => [OpenStruct.new(:id => 1, :sku => "11111", :title => "VT", barcode: "1231231", price: 10.3)])
      @product2 = OpenStruct.new(:id => 4444, :name => "Sample Product", :variants => [OpenStruct.new(:id => 2, :sku => "343434", :title => nil, barcode: "123412345", price: 10.3)])
      @product3 = OpenStruct.new(:id => 5555, :name => "Demo Product", :variants => [OpenStruct.new(:id => 3, :sku => "abc123", :title => "", barcode: "3453245345", price: 10.3)])

      DateTime.stub(:now) {DateTime.new(2013, 10, 9, 12, 10)}

      @product = OpenStruct.new()
      @product.stub(:save) {true}

    end

    it "should map the proper properties on create" do
      Product.should_receive(:new).with(last_shopify_sync: DateTime.now,
                                        name: @product1.title,
                                        shopify_product_id: @product1.id,
                                        account_id: 1
                                        ).and_return(@product)


      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product1]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      @shopify_integration.import_products

    end

    it "should create a new product if it doesn't exist" do
      product = FactoryGirl.create(:product, :shopify_product_id => 99999)
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "1234", :shopify_variant_id => 8888)
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product1, @product2]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      result = @shopify_integration.import_products
      result[:created].should == 2
      result[:updated].should == 0
      result[:failed].should == 0


    end



    it "should update an existing product if it already exists" do
      product = FactoryGirl.create(:product, :name => "Old Name", :shopify_product_id => 99999)
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "abc123", :shopify_variant_id => 3)


      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product3]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      result = @shopify_integration.import_products
      result[:created].should == 0
      result[:updated].should == 1
      result[:failed].should == 0

    end

    it "should page through until there are no more products" do
      product = FactoryGirl.create(:product, :name => "Old Name", :shopify_product_id => 99999)
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "abc123", :shopify_variant_id => 3)
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product1, @product3]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      result = @shopify_integration.import_products
      result[:created].should == 1
      result[:updated].should == 1
      result[:failed].should == 0


    end

    it "should report failure to create product" do
      product = Product.new(:name => "Old Name", :shopify_product_id => 99999 )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product1]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )


      Product.should_receive(:find_by_shopify_product_id).and_return(nil)

      Product.should_receive(:new).and_return(product)
      product.should_receive(:save).and_return(false)

      result = @shopify_integration.import_products
      result[:created].should == 0
      result[:updated].should == 0
      result[:failed].should == 1
    end

    it "should report failure to update product" do
      product = FactoryGirl.create(:product, :name => "Old Name", :shopify_product_id => 99999)
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "abc123", :shopify_variant_id => 3)

      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product3]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      Product.should_receive(:find_by_shopify_product_id).and_return(product)
      product.should_receive(:update_attributes).and_return(false)


      result = @shopify_integration.import_products
      result[:created].should == 0
      result[:updated].should == 0
      result[:failed].should == 1
    end

    it "should report failure to create variant" do
      product = Product.new(:name => "Old Name", :shopify_product_id => 99999 )
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "abc123", :shopify_variant_id => 3)
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product1]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )


      Variant.should_receive(:find_by_shopify_variant_id).and_return(nil)

      Variant.should_receive(:create).and_return(false)

      result = @shopify_integration.import_products
      result[:created].should == 0
      result[:updated].should == 0
      result[:failed].should == 1
    end

    it "should report failure to update variant" do
      product = FactoryGirl.create(:product, :name => "Old Name", :shopify_product_id => 99999)
      variant = FactoryGirl.create(:variant, :product_id => product.id, :sku => "abc123", :shopify_variant_id => 3)

      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 1}).and_return(
        [@product3]
      )
      ShopifyAPI::Product.should_receive(:find).with(:all, :params => {:limit => 100, :page => 2}).and_return(
        []
      )

      Variant.should_receive(:find_by_shopify_variant_id).and_return(variant)
      variant.should_receive(:update_attributes).and_return(false)


      result = @shopify_integration.import_products
      result[:created].should == 0
      result[:updated].should == 0
      result[:failed].should == 1
    end

  end


  context "import_orders" do

    before do

      @shopify_integration = ShopifyIntegration.new(
        :url => "http://url.to.store",
        :password => "secretsecret",
        :account_id => 1
      )

      @order1 = OpenStruct.new(:id => 1234,
                               :name => "#1000",
                               :email => "test@example.com",
                               :created_at => DateTime.now,
                               :total => 10.00,
                               :financial_status => "paid",
                               :billing_address => OpenStruct.new(:id => 1, :first_name => "Mickey", :last_name => "Mouse", :email => "mickey@mouse.com",
                                                                  :address1 => "333 Main St", :address2 => "Apt 3", :city => "Townville", :provice_code => "AB",
                                                                  :zip => "12345", :country_code => "US", :phone => "555-555-1234"),
                               :line_items => [OpenStruct.new(:id => 1, :product_id => 1234, :sku => "11111", :quantity => 1, :price => 15.0)],
                               )

      @order2 = OpenStruct.new(:id => 4444,
                               :name => "#1001",
                               :email => "test@example.com",
                               :created_at => DateTime.now,
                               :total => 10.00,
                               :financial_status => "paid",
                               :billing_address => OpenStruct.new(:id => 1, :first_name => "Daffy", :last_name => "Duck", :email => "daffy@duck.com",
                                                                  :address1 => "333 Main St", :city => "Townville", :provice_code => "AB",
                                                                  :zip => "12345", :country_code => "US", :phone => "555-555-1234"),
                               :line_items => [OpenStruct.new(:id => 1, :product_id => 1234, :sku => "11111", :quantity => 1, :price => 15.0)],
                               )

      @order3 = OpenStruct.new(:id => 5555,
                               :name => "#1002",
                               :email => "test@example.com",
                               :created_at => DateTime.now,
                               :total => 10.00,
                               :financial_status => "paid",
                               :billing_address => OpenStruct.new(:id => 1, :first_name => "Donald", :last_name => "Duck", :email => "donald@duck.com",:address1 => "333 Main St", :address2 => "Apt 3", :city => "Townville", :provice_code => "AB",
                                                                  :zip => "12345", :country_code => "US", :phone => "555-555-1234"),
                               :line_items => [OpenStruct.new(:id => 1, :product_id => 1234, :sku => "11111", :quantity => 1, :price => 15.0), OpenStruct.new(:id => 2, :product_id => 4567, :sku => "4444", :quantity => 2, :price => 15.0)],

                               )
      @order = OpenStruct.new()
      @order.stub(:save) {true}

    end

    it "should map the correct product properties on create" do
      # If not already imported, create a new order
      Order.should_receive(:new).with(number: @order1.name,
                                      email: @order1.email,
                                      first_name: @order1.billing_address.first_name,
                                      last_name: @order1.billing_address.last_name,
                                      shopify_order_id: @order1.id,
                                      order_date: @order1.created_at,
                                      total: @order1.total_price,
                                      financial_status: @order1.financial_status,
                                      account_id: @account.id
                                      ).and_return(@order)

      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 1}).and_return(
      [@order1])

      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 2}).and_return(
      [])

      @shopify_integration.import_orders

    end



    it "should create a new order if it doesn't exist" do
      order = FactoryGirl.create(:order, :shopify_order_id => 99999)

      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 1}).and_return(
        [@order1, @order2]
      )
      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 2}).and_return(
        []
      )

      result = result = @shopify_integration.import_orders
      result[:created].should == 2
      result[:failed].should == 0


    end


    it "should report failure to create order" do
      order = Order.new(:number => "#1001", :shopify_order_id => 99999 )

      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 1}).and_return(
        [@order1]
      )
      ShopifyAPI::Order.should_receive(:find).with(:all, :params => {:limit => 50, :page => 2}).and_return(
        []
      )

      Order.should_receive(:find_by_shopify_order_id).and_return(nil)

      Order.should_receive(:new).and_return(order)
      order.should_receive(:save).and_return(false)

      result = @shopify_integration.import_orders
      result[:created].should == 0
      result[:failed].should == 1
    end

  end

context "update_account" do

    before do
      @shopify_integration = ShopifyIntegration.new(
        :url => "http://url.to.store",
        :password => "secretsecret",
        :account_id => @account.id
      )
      @shopify_integration.connect

      @shop_response = OpenStruct.new(name: "Test Shop", id: 1231231, domain: "test-shop.com", shop_owner: "Daffy Duck",
                                      email: "daffy@duck.com", address1: "123 Duck Road", city: "Duckville",
                                      province_code: "AL", province: "Alabama", country: "United States", zip: "12345",
                                      phone: "555-555-1234", plan_name: "enterprise", timezone: "EST")
    end

    it "should grab the current shop from Shopify and map the fields" do
      Account.should_receive(:find).and_return(@account)

      ShopifyAPI::Shop.should_receive(:current).and_return(@shop_response)
      @account.should_receive(:shopify_shop_name=).with(@shop_response.name)
      @account.should_receive(:shopify_shop_id=).with(@shop_response.id)
      @account.should_receive(:shop_owner=).with(@shop_response.shop_owner)
      @account.should_receive(:email=).with(@shop_response.email)

      @account.should_receive(:save)

      @shopify_integration.update_account
    end


  end



  ###### Class Methods ######
  context "self.verify" do

    it "should return true if the signature matches" do
      # Assume we have the query parameters in a hash
      query_parameters = { shop: "some-shop.myshopify.com",
                           code: "a94a110d86d2452eb3e2af4cfb8a3828",
                           timestamp: "1337178173",
                           signature: "929b77106a419bde96b151b318557a11"}

      ShopifyIntegration.verify(query_parameters).should be_true

    end

    it "should return false if the signature DOES NOT match" do
      # Assume we have the query parameters in a hash
      query_parameters = { shop: "some-shop.myshopify.com",
                           code:  "a94a110d86d2452eb3e2af4cfb8a3828",
                           timestamp: "1337178173",
                           signature: "929b77106a419bde96b151b318557234"} # Changed

      ShopifyIntegration.verify(query_parameters).should be_false
    end

  end

end