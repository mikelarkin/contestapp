class AddChargeIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :charge_id, :integer
  end
end
