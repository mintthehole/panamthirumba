class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :aadhaar_no
      t.string :email
      t.string :phone_no
      t.string :name

      t.timestamps
    end
  end
end
