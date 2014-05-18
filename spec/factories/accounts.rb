# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    shopify_account_url "MyString"
    shopify_api_key "MyString"
    shopify_password "MyString"
    shopify_shared_secret "MyString"
  end
end
