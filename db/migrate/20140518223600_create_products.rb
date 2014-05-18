class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :shopify_product_id
      t.datetime :last_shopify_sync

      t.timestamps
    end
  end
end
