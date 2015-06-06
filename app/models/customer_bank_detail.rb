class CustomerBankDetail < ActiveRecord::Base
  attr_accessible :bank_detail_id, :customer_id
  belongs_to :customer
  belongs_to :bank_detail
end
