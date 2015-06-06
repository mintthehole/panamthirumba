class Merchant < ActiveRecord::Base
  attr_accessible :address, :name, :phone_no, :tan_no, :user_id
  validates_presence_of :name,:phone_no
  belongs_to :user


  def email
  	user.try(:email)
  end

  def build_hash
  	{:phoneNo => self.try(:phone_no), :name => self.try(:name), :tanNo => self.try(:tan_no)}
  end


  def self.build(hash)
  	Merchant.new(:name => hash[:name], :phone_no => hash[:phone_no], :tan_no => hash[:tan_no])
  end

end
