# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    number "MyString"
    email "MyString"
    first_name "MyString"
    last_name "MyString"
    shopify_order_id 1
    order_date "2014-05-18 20:51:41"
    total 1.5
    line_item_count 1
    financial_status "MyString"
  end
end
