class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :user_id
      t.string :phone_no
      t.string :name
      t.string :tan_no
      t.string :address

      t.timestamps
    end
  end
end
