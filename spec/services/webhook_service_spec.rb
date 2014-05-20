require 'spec_helper'

describe WebhookService do

  before do
    @account = FactoryGirl.create(:account)
  end
  context "initialize" do
    it "should set the @request instance variable" do

      request = ActionController::TestRequest.new
      webhook_service = WebhookService.new(request, @account)
      webhook_service.request.should eq(request)
      webhook_service.account.should eq(@account)
    end
  end


  context "verify_webhook" do

    it "should return true if test header is set correctly" do
      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_TEST"] = true
      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should be_true

      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_TEST"] = "true"
      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should be_true
    end

    it "should NOT return true if test header is set incorrectly" do
      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_TEST"] = "foo"
      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should_not be_true
    end

    it "should return false if the hmac header isn't present" do

      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_HMAC_SHA512"] = "1234"
      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should be_false
    end

    it "should return true if the data verifies" do

      # Create a new digest
      digest = OpenSSL::Digest::Digest.new('sha256')

      # Encode our test data
      test_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHOPIFY_SHARED_SECRET, "this is test data {'order':'1234'}")).strip

      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_HMAC_SHA256"] = test_hmac
      request.env["RAW_POST_DATA"] = "this is test data {'order':'1234'}"


      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should be_true
    end

    it "should return false if the data does NOT verify" do
      # Create a new digest
      digest = OpenSSL::Digest::Digest.new('sha256')

      # Encode our test data
      test_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHOPIFY_SHARED_SECRET, "this is NOT test data {'order':'1234'}")).strip

      request = ActionController::TestRequest.new
      request.env["HTTP_X_SHOPIFY_HMAC_SHA256"] = test_hmac
      request.env["RAW_POST_DATA"] = "this is test data {'order':'1234'}"


      webhook_service = WebhookService.new(request, @account)
      webhook_service.verify_webhook.should be_false
    end

  end
end
