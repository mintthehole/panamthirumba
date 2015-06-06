class Merchant < ActiveRecord::Base
  attr_accessible :address, :name, :phone_no, :tan_no, :user_id
  validates_presence_of :name,:phone_no
  belongs_to :user
end
