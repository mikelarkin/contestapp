require "spec_helper"

describe ShopifyController do
  describe "routing" do

    it "routes to #authorize" do
      get("/shopify/authorize").should route_to("shopify#authorize")
      post("/shopify/authorize").should route_to("shopify#authorize")
    end

    it "routes to #install" do
      get("/shopify/install").should route_to("shopify#install")
      post("/shopify/install").should route_to("shopify#install")
    end

  end
end
