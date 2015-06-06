class CreateCustomerBankDetails < ActiveRecord::Migration
  def change
    create_table :customer_bank_details do |t|
      t.integer :customer_id
      t.integer :bank_detail

      t.timestamps
    end
  end
end
