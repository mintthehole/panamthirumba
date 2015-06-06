class Customer < ActiveRecord::Base
  attr_accessible :aadhaar_no, :email, :name, :phone_no
  validates_presence_of :aadhaar_no
  has_one :bank_detail
  require 'json'
  KYC_ERRORS = {"K-100" => "Resident authentication failed",
  "K-200" => "Resident data currently not available",
  "K-540" => "Invalid KYC XML",
  "K-541" => "Invalid e-KYC API version",
  "K-542" => "Invalid resident consent ('rc' attribute in 'Kyc' element)",
  "K-543" => "Invalid timestamp ('ts' attribute in 'Kyc' element)",
  "K-544" => "Invalid resident auth type ('ra' attribute in 'Kyc' element does not match what is in PID block)",
  "K-545" => "Resident has opted-out of this service",
  "K-550" => "Invalid Uses Attribute",
  "K-551" => "Invalid 'Txn' namespace",
  "K-552" => "Invalid License key",
  "K-569" => "Digital signature verification failed for e-KYC XML",
  "K-570" => "Invalid key info in digital signature for e-KYC XML (it is either expired, or does not belong to the AUA or is not created by a well-known Certification Authority)",
  "K-600" => "AUA is invalid or not an authorized KUA",
  "K-601" => "ASA is invalid or not an authorized KSA",
  "K-602" => "KUA encryption key not available",
  "K-603" => "KSA encryption key not available",
  "K-604" => "KSA Signature not allowed",
  "K-605" => "Neither KUA key nor KSA encryption key are available",
  "K-955" => "Technical Failure",
  "K-999" => "Unknown error"}

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
    	response = curl_method(otp_hash,'https://ac.khoslalabs.com/hackgate/hackathon/otp')
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
      response = curl_method(basic_details_hash,"https://ac.khoslalabs.com/hackgate/hackathon/kyc/raw")
      response_body = JSON.parse response.body_str
      if response_body["success"]
        response_body["kyc"]
      else
        status_code = response_body["aadhaar-status-code"]
        Customer::KYC_ERRORS[status_code]
      end
    end
  end
end
