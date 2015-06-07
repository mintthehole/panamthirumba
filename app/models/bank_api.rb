class BankApi < BaseResource 
	def self.get_bank_details(aadhar_id)
		begin
			self.get("get_bank_details/#{aadhar_id}")	
		rescue Exception => e
			{}
		end
		
	end

	def self.get_signature(data)
		self.get("generate_signature",{:data => data})
	end
end