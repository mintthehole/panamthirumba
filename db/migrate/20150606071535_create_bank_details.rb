class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.string :ac_no
      t.string :name
      t.string :ifsc_code

      t.timestamps
    end
  end
end
