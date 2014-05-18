json.array!(@accounts) do |account|
  json.extract! account, :id, :shopify_account_url, :shopify_api_key, :shopify_password, :shopify_shared_secret
  json.url account_url(account, format: :json)
end
