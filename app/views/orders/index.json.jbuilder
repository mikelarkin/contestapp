json.array!(@orders) do |order|
  json.extract! order, :id, :number, :email, :first_name, :last_name, :shopify_order_id, :order_date, :total, :line_item_count, :financial_status
  json.url order_url(order, format: :json)
end
