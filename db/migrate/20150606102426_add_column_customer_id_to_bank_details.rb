class AddColumnCustomerIdToBankDetails < ActiveRecord::Migration
  def change
    add_column :bank_details, :customer_id, :integer
  end
end
