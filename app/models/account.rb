class Account < ActiveRecord::Base
  validates_presence_of :shopify_account_url
  validates_presence_of :shopify_password

  has_many :orders, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :contests, :dependent => :destroy
end
