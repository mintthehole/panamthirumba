class BankDetail < ActiveRecord::Base
  attr_accessible :ac_no, :ifsc_code, :name, :customer_id
  validates_presence_of :ac_no, :ifsc_code, :name, :customer_id
  belongs_to :customer

  def self.build(hash)
  	self.new(:ac_no =>hash[:acc_no], :ifsc_code => hash[:ifsc])
  end
end
