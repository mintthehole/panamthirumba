class Customer < ActiveRecord::Base
  attr_accessible :aadhaar_no, :email, :name, :phone_no
  validates_presence_of :aadhaar_no
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

  class << self
    def send_otp(aadhaar_no)
      # Aadhaar Api to send otp
      otp_hash = build_otp_hash(aadhaar_no)
    	response = curl_method(otp_hash, Settings.otp_url)
      response_body = JSON.parse response.body_str
      response_body["success"]
    end

    def curl_method(hash,url)
      c = Curl::Easy.http_post(url, hash.to_json) do |curl|
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
      end
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

    def authenticate
    	# aadhar api to autheticate and get the name,email
    end

    def get_basic_details(otp,aadhaar_no)
    	# aadhar api to autheticate and get the basic details
      basic_details_hash = build_basic_details_hash(otp,aadhaar_no)
      response = curl_method(basic_details_hash, Settings.basic_details_url)
      response_body = JSON.parse response.body_str
      if response_body["success"]
        response_body["kyc"]
      else
        status_code = response_body["aadhaar-status-code"]
        Settings.kyc_errors[status_code]
      end
    end
  end
end
