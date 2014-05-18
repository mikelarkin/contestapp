class Account < ActiveRecord::Base
  validates_presence_of :shopify_account_url
  validates_presence_of :shopify_api_key
  validates_presence_of :shopify_password
  validates_presence_of :shopify_shared_secret
end
