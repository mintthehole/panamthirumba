class Transaction < ActiveRecord::Base
  attr_accessible :refund_id, :status, :txn_ref_no, :txn_type
  belongs_to :refund

  validates_presence_of :txn_type,:status,:txn_ref_no,:refund_id
  TYPES = [
  	INWARD = "Inward",
  	OUTWARD = "OutWard"
  ]


  def build(hash)
  	self.staus = 'New'
  	self.txn_type = hash[:type]
  	self.refund_id = hash[:refund_id]
  	self
  end

  def get_signature(string)
  	# Call API to get signature
  end

end
