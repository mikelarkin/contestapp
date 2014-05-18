require "spec_helper"

describe VariantsController do
  describe "routing" do

    it "routes to #index" do
      get("/products/1/variants").should route_to("variants#index", :product_id => "1")
    end

    it "routes to #new" do
      get("/products/1/variants/new").should route_to("variants#new", :product_id => "1")
    end

    it "routes to #show" do
      get("/products/1/variants/2").should route_to("variants#show", :product_id => "1", :id => "2")
    end

    it "routes to #edit" do
      get("/products/1/variants/2/edit").should route_to("variants#edit", :product_id => "1", :id => "2")
    end

    it "routes to #create" do
      post("/products/1/variants").should route_to("variants#create", :product_id => "1")
    end

    it "routes to #update" do
      put("/products/1/variants/2").should route_to("variants#update", :product_id => "1", :id => "2")
    end

    it "routes to #destroy" do
      delete("/products/1/variants/2").should route_to("variants#destroy", :product_id => "1", :id => "2")
    end

  end
end
