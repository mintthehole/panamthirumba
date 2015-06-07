class Transaction < ActiveRecord::Base
  attr_accessible :refund_id, :status, :txn_ref_no, :txn_type
  belongs_to :refund

  validates_presence_of :txn_type,:status,:refund_id
  TYPES = [
  	INWARD = "Inward",
  	OUTWARD = "OutWard"
  ]

  STATUS = [
    NEW = "New",
    COMPLETED = "Completed",
    FAILED = 'Failed'
  ]

  def self.build(hash)
    txn = self.new
  	txn.status = 'New'
  	txn.txn_type = hash[:type]
  	txn.refund_id = hash[:refund_id]
  	txn
  end
end
