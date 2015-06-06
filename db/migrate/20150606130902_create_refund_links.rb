class CreateRefundLinks < ActiveRecord::Migration
  def change
    create_table :refund_links do |t|
      t.string :link
      t.boolean :is_valid, :default => false
      t.integer :no_of_attempts, :default => 0

      t.timestamps
    end
  end
end
