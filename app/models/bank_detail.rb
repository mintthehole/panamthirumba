class BankDetail < ActiveRecord::Base
  attr_accessible :ac_no, :ifsc_code, :name, :customer_id
  validates_presence_of :ac_no, :ifsc_code, :name, :customer_id
  belongs_to :customer
end
