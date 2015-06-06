class Customer < ActiveRecord::Base
  attr_accessible :aadhaar_no, :email, :name, :phone_no
  validates_presence_of :aadhaar_no
  has_one :bank_detail

  def get_bank_detail
    details = BankApi.get_bank_details(aadhaar_no)
    bank_detail = BankDetail.new(details)
    if bank_detail.try(:ac_no).present?
      bank_detail.customer_id = self.id
      bank_detail.save
    else
      bank_detail = nil
    end
    bank_detail
  end

  def send_otp
  	# Aadhaar Api to send otp
  end

  def authenticate
  	# aadhar api to autheticate and get the name,email
  end

  def get_basic_details
  	# aadhar api to autheticate and get the basic details
  end


end
