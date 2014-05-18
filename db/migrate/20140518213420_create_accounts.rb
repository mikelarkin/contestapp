class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :shopify_account_url
      t.string :shopify_api_key
      t.string :shopify_password
      t.string :shopify_shared_secret

      t.timestamps
    end
  end
end
