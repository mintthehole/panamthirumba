class Refund < ActiveRecord::Base
  attr_accessible :amount, :bank_detail_id, :customer_id, :merchant_id, :state, :customer_in_store
  belongs_to :customer
  belongs_to :merchant
  belongs_to :bank_detail
  has_many :transactions
  
  validates_presence_of :state, :customer_id,:amount,:merchant_id
 
  STATES = [
  	INITIATED = "Initiated",
  	PAID = "Paid",
  	CONFIRMED = "Confirmed",
  	CANCELLED = "Cancelled",
  	COMPLETED = "Completed",
  	FAILED = "Failed"
  ]

end