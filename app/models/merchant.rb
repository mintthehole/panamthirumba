class Merchant < ActiveRecord::Base
  attr_accessible :address, :name, :phone_no, :tan_no, :user_id
  validates_presence_of :name,:phone_no
  belongs_to :user


  def email
  	user.try(:email)
  end

  def update_params(hash)
  	self.phone_no = hash[:phone_no]
  	self.name = hash[:name]
  	self.tan_no = hash[:tan_no]
  end

  def build_hash
  	{:phone_no => self.try(:phone_no), :name => self.try(:name), :tan_no => self.try(:tan_no)}
  end


  def self.build(hash)
  	Merchant.new(:name => hash[:name], :phone_no => hash[:phone_no], :tan_no => hash[:tan_no])
  end

end
