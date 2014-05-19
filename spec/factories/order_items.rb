# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item do
    order_id 1
    variant_id 1
    shopify_product_id 1
    shopify_variant_id 1
    unit_price 1.5
    quantity 1
  end
end
