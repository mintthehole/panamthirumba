class Refund < ActiveRecord::Base
  attr_accessible :amount, :bank_detail_id, :customer_id, :merchant_id, :state, :customer_in_store
  belongs_to :customer
  belongs_to :merchant
  belongs_to :bank_detail
  has_many :transactions
  has_one :refund_link
  after_create :create_refund_link, unless: :customer_in_store?
  
  validates_presence_of :state, :customer_id,:amount,:merchant_id
 
  STATES = [
  	INITIATED = "Initiated",
  	PAID = "Paid",
  	CONFIRMED = "Confirmed",
  	CANCELLED = "Cancelled",
  	COMPLETED = "Completed",
  	FAILED = "Failed"
  ]


  def create_refund_link
    bitly_link = Bitly.client.shorten("#{Settings.site_url}/refund/#{self.id}")
    refund_link = RefundLink.new(:link => bitly_link.short_url, :refund_id => self.id)
    refund_link.save
    send_sms
  end

  def send_sms
    if Settings.send_sms
      begin
        # response = Exotel::Sms.send(:from => Settings.from_phone_no, :to => 9538555456, :body => "Your refund link '#{self.refund_link.link}'")
        response = Exotel::Sms.send(:from => Settings.from_phone_no, :to => 9538555456, :body => "Your refund link ")
      rescue Exception => e
        p e.to_s
        # exotel_xml = e.to_s
        # exotel_hash = Hash.from_xml(exotel_xml.gsub("\n", ""))
        # status, msg = OtrMember.exotel_exception_check(exotel_hash)
      end
    end
  end
  
end