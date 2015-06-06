class BankApi < BaseResource 
	def self.get_bank_details(aadhar_id)
		self.get("get_bank_details/#{aadhar_id}")
	end

	def self.get_signature(data)
		self.get("generate_signature/#{data}")
	end
end