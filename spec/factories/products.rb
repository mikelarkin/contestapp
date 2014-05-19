# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence :name do |n|
      "Product #{n}"
    end

    shopify_product_id {rand(10000000)}

    last_shopify_sync {DateTime.now - rand(5).days}
  end
end