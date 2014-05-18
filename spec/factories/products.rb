# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "MyString"
    shopify_product_id 1
    last_shopify_sync "2014-05-18 18:36:00"
  end
end
