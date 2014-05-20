require "spec_helper"

describe WebhooksController do
  describe "routing" do

    it "routes GETs to #uninstall" do
      get("/webhooks/uninstall").should route_to("webhooks#uninstall")
    end

    it "routes POSTs to #uninstall" do
      post("/webhooks/uninstall").should route_to("webhooks#uninstall")
    end
  end
end

