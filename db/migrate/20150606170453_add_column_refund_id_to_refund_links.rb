class AddColumnRefundIdToRefundLinks < ActiveRecord::Migration
  def change
    add_column :refund_links, :refund_id, :integer
  end
end
