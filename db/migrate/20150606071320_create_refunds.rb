class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.integer :merchant_id
      t.integer :customer_id
      t.integer :bank_detail_id
      t.float :amount
      t.string :state

      t.timestamps
    end
  end
end
