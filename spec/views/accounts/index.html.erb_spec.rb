require 'spec_helper'

describe "accounts/index" do
  before(:each) do
    assign(:accounts, [
      stub_model(Account,
        :shopify_account_url => "Shopify Account Url",
        :shopify_api_key => "Shopify Api Key",
        :shopify_password => "Shopify Password",
        :shopify_shared_secret => "Shopify Shared Secret",
        :created_at => DateTime.now
      ),
      stub_model(Account,
        :shopify_account_url => "Shopify Account Url",
        :shopify_api_key => "Shopify Api Key",
        :shopify_password => "Shopify Password",
        :shopify_shared_secret => "Shopify Shared Secret",
        :created_at => DateTime.now
      )
    ])
  end

  it "renders a list of accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Shopify Account Url".to_s, :count => 2
    assert_select "tr>td", :text => "Shopify Api Key".to_s, :count => 2
    assert_select "tr>td", :text => "Shopify Password".to_s, :count => 2
    assert_select "tr>td", :text => "Shopify Shared Secret".to_s, :count => 2
  end
end
