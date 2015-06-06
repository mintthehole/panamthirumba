class AddColumnBankDetailIdToCustomerBankDetails < ActiveRecord::Migration
  def change
  	remove_column :customer_bank_details, :bank_detail
    add_column :customer_bank_details, :bank_detail_id, :integer
    add_column :refunds, :customer_in_store, :boolean, :default => false
  end
end
