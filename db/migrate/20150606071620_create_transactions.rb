class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :refund_id
      t.string :status
      t.string :txn_ref_no
      t.string :txn_type

      t.timestamps
    end
  end
end
