class Customer < ActiveRecord::Base
  attr_accessible :aadhaar_no, :email, :name, :phone_no
  validates_presence_of :aadhaar_no
  validates_uniqueness_of :aadhaar_no
  has_one :bank_detail
  require 'json'

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
    otp_hash = build_otp_hash(aadhaar_no)
    otp_response(otp_hash)
  end


  def curl_method(hash,url)
    c = Curl::Easy.http_post(url, hash.to_json) do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
    end
  end

  def otp_response(otp_hash)
    response = curl_method(otp_hash, Settings.otp_url)
    response_body = JSON.parse response.body_str
    response_body["success"]
  end

  def build_otp_hash(aadhaar_no)
    {"aadhaar-id" => "#{aadhaar_no}",
    "location" => {},
    "channel" => "SMS"
    }
  end

  def build_basic_details_hash(otp,aadhaar_no)
    {
    "consent"=> "Y",
    "auth-capture-request"=> {
    "aadhaar-id"=> "#{aadhaar_no}",
    "modality"=> "otp",
    "otp"=> "#{otp}",
    "device-id"=> "public",
    "certificate-type"=> "preprod",
    "location"=> {
    "type"=> "pincode",
    "pincode"=> "560001"
    }
    }
    }
  end


  def get_basic_details(otp,aadhaar_no)
  	# aadhar api to autheticate and get the basic details
    # basic_details_hash = build_basic_details_hash(otp,aadhaar_no)
    # response = curl_method(basic_details_hash, Settings.basic_details_url)
    # response_body = JSON.parse response.body_str
    # if response_body["success"]
    #   p response_body['kyc']
    #   p {:success => response_body["success"], :name => ""}
    # else
    #   status_code = response_body["aadhaar-status-code"]
    #   {:success => response_body["kyc"], :error_code => Settings.kyc_errors[status_code]}
    # end
  end

  def self.build(params)
    cus = Customer.find_by_aadhaar_no(params[:aadhaar])
    cus = self.new(:aadhaar_no => params[:aadhaar], :email => params[:email], :phone_no => params[:phone_no]) unless cus
    cus
  end
end
