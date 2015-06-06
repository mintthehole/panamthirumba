class Refund < ActiveRecord::Base
  attr_accessible :amount, :bank_detail_id, :customer_id, :merchant_id, :state, :customer_in_store
  belongs_to :customer
  belongs_to :merchant
  belongs_to :bank_detail
  has_many :transactions
  
  validates_presence_of :state,:amount,:merchant_id

  STATES = [
  	INITIATED = "Initiated",
  	PAID = "Paid",
  	CONFIRMED = "Confirmed",
  	CANCELLED = "Cancelled",
  	COMPLETED = "Completed",
  	FAILED = "Failed"
  ]

  def aadhaar_verfication
    customer.send_otp
  end

  def reverse_payment_transaction
    # REVERSE PAYMENT IF YOU FIND
  end
  
  def cancel
    hash = {}
    if state != COMPLETED && state != CANCELLED
      self.state = CANCELLED
      self.save
      self.reverse_payment_transaction
      hash = {:success => true}
    else
      hash = {:success => false, :error => "Can't be Cancelled."}
    end
    hash
  end


  def refund_hash
    customer = self.try(:customer)
    {:name => customer.try(:name),:email =>customer.try(:name),:id => id,
     :phone_no =>customer.try(:phone_no) ,:aadhaar => customer.try(:aadhaar_no),
     :transanction_no =>nil ,:status => state,:date=>created_at.strftime("%d-%m-%Y")}
  end

  def self.build(params)
    self.new(:state => Refund::INITIATED, :amount => params[:amount], :customer_in_store => params[:isCustomerPresent])
  end

end