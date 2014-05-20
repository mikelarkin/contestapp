class AccountRework < ActiveRecord::Migration
  def change
  	 # These columns are not unique but global
       remove_column :accounts, :shopify_shared_secret
       remove_column :accounts, :shopify_api_key
       # We need to store more information about the shop
       add_column :accounts, :shopify_shop_id, :integer
       add_column :accounts, :shopify_shop_name, :string
       add_column :accounts, :shop_owner, :string
       add_column :accounts, :email, :string
       # Index commonly searched for fields
       add_index :accounts, :shopify_account_url
       add_index :accounts, :email
  end
end
