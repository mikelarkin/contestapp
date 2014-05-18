require 'spec_helper'

describe "accounts/show" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :shopify_account_url => "Shopify Account Url",
      :shopify_api_key => "Shopify Api Key",
      :shopify_password => "Shopify Password",
      :shopify_shared_secret => "Shopify Shared Secret"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Shopify Account Url/)
    rendered.should match(/Shopify Api Key/)
    rendered.should match(/Shopify Password/)
    rendered.should match(/Shopify Shared Secret/)
  end
end
