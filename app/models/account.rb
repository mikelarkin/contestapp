class Account < ActiveRecord::Base
  validates_presence_of :shopify_account_url
  validates_presence_of :shopify_password
end
