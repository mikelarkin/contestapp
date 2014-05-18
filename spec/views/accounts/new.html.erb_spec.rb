require 'spec_helper'

describe "accounts/new" do
  before(:each) do
    assign(:account, stub_model(Account,
      :shopify_account_url => "MyString",
      :shopify_api_key => "MyString",
      :shopify_password => "MyString",
      :shopify_shared_secret => "MyString"
    ).as_new_record)
  end

  it "renders new account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", accounts_path, "post" do
      assert_select "input#account_shopify_account_url[name=?]", "account[shopify_account_url]"
      assert_select "input#account_shopify_api_key[name=?]", "account[shopify_api_key]"
      assert_select "input#account_shopify_password[name=?]", "account[shopify_password]"
      assert_select "input#account_shopify_shared_secret[name=?]", "account[shopify_shared_secret]"
    end
  end
end
