class Transaction < ActiveRecord::Base
  attr_accessible :refund_id, :status, :txn_ref_no, :txn_type
  belongs_to :refund
  validates_presence_of :txn_type,:status,:txn_ref_no,:refund_id
  TYPES = [
  	INWARD = "Inward",
  	OUTWARD = "OutWard"
  ]
end
