class Customer < ActiveRecord::Base
  attr_accessible :aadhaar_no, :email, :name, :phone_no
  validates_presence_of :aadhaar_no
  has_many :bank_details, :through => :customer_bank_details
end
