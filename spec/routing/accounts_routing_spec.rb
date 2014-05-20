require "spec_helper"

describe AccountsController do
  describe "routing" do

    it "routes to #edit" do
      get("/account").should route_to("accounts#edit")
    end

    it "routes PUTs to #update" do
      put("/account").should route_to("accounts#update")
    end

    it "routes PATCHs to #update" do
      patch("/account").should route_to("accounts#update")
    end

  end
end
