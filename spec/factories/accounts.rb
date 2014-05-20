
FactoryGirl.define do
  factory :account do
    # Use a sequence to ensure unique values
    sequence :shopify_account_url do |n|
      "test-#{n}.myshopify.com"
    end
    shopify_password "MyString"
    created_at {DateTime.now}
    updated_at {DateTime.now}
    # Use a large random number to ensure unique values
    shopify_shop_id {rand 9999999}
    sequence :shopify_shop_name do |n|
      "shop_#{n}"
    end
    shop_owner "Bugs Bunny"
    # Use a sequence to ensure unique values
    sequence :email do |n|
      "owner_#{n}@example.com"
    end

    paid true
  end
end
