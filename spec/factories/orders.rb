# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    sequence :number do |n|
      "Order #{n}"
    end

    sequence :email do |n|
      "email-#{n}@gmail.com"
    end

    sequence :first_name do |n|
      "Customer #{n}"
    end

    last_name "MyString"

    shopify_order_id {rand(100000)}
    order_date "2013-11-05 02:02:56"
    total 1.5
    line_item_count 1
    financial_status "paid"
  end
end