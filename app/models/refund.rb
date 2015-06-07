class Refund < ActiveRecord::Base
  attr_accessible :amount, :bank_detail_id, :customer_id, :merchant_id, :state, :customer_in_store
  
  belongs_to :customer
  belongs_to :merchant
  belongs_to :bank_detail
  has_many :transactions
  has_one :refund_link
  

  validates_presence_of :state,:amount,:merchant_id

  after_create :create_refund_link, unless: :customer_in_store?

  STATES = [
  	INITIATED = "Initiated",
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
        response = Exotel::Sms.send(:from => Settings.from_phone_no, :to => refund.customer.try(:phone_no).to_s.last(10).to_i, :body => "Your refund link #{self.refund_link.link}")
      rescue Exception => e
        p e.to_s
      end
    end
  end

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

  def customer_has_account?
    bank_detail_id.present?
  end

  def has_merchant_paid?
    transactions.where(:txn_type => Transaction::INWARD, :status => Transaction::COMPLETED).present?
  end

  def refund_detailed_hash
    refund_hash.merge(:has_paid => has_merchant_paid?, :has_account => customer_has_account?)
  end

  def auth_and_bank(otp)
    response = customer.get_basic_details(otp)
    if response[:success]
      response[:id] = self.id
      customer.name = response[:name]
      customer.save
      self.state = CONFIRMED
      bank = customer.get_bank_detail
      if bank
        self.bank_detail = bank
        response[:has_account] = true 
      else
        response[:has_account] = false
      end
      self.save
    end
    response
  end


  def generate_bill(request_url)
    access_key = Settings.citrus_access_key
    transaction = Transaction.build({:type => Transaction::INWARD,:refund_id =>self.id})
    transaction.save
    data_string = "merchantAccessKey=#{access_key}&transactionId=#{transaction.id}&amount=#{amount.to_i}"
    signature = BankApi.get_signature(data_string)
    return_url = request_url + Settings.payment_return_url
    {'merchantTxnId' => transaction.id,
     'amount' => {'value' => amount.to_i, 'currency' => 'INR'},
     'requestSignature' => signature,
     'merchantAccessKey' => Settings.citrus_access_key,
     'returnUrl' => return_url}
  end

  def refund_hash
    customer = self.try(:customer)
    {
      :name => customer.try(:name),:email =>customer.try(:name),
      :amount => amount,:id => id,
      :phone_no =>customer.try(:phone_no) ,:aadhaar => customer.try(:aadhaar_no),
      :transanction_no =>id ,:status => state,:date=>created_at.strftime("%d-%m-%Y")
    }
  end

  def self.build(params)
    self.new(:state => Refund::INITIATED, :amount => params[:amount], :customer_in_store => params[:isCustomerPresent])
  end

end