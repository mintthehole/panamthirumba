class Api::V1::MerchantsController < ApplicationController
	respond_to :xml, :json
	before_filter :load_merchant, :except => [:get_info, :profile_update]

	def get_transfers
		refunds = Refund.where(:merchant_id => @merchant.id)
		render :json => refunds.collect(&:refund_hash)
	end

	def create_refund
		cus = Customer.build(params)
		if cus.valid?
			refund = Refund.build(params)
			refund.merchant = @merchant
			refund.customer = cus
			if refund.save
				flag = true
				error = nil
				id = refund.id
				if refund.customer_in_store
					flag = refund.aadhaar_verfication
					unless flag
						error = "Invalid Aadhaar Number" 
						refund.delete
						id = nil
					end
				end
				render :json => {:success => flag, :error => error, :id => id}
			else
				render :json => {:success => false, :error => refund.errors.to_a.join(",")}
			end
		else
			render :json => {:success => false, :error => cus.errors.to_a.join(",")}
		end
	end

	def get_info
		render :json => @current_resource.try(:merchant).try(:build_hash) || {}
	end

	def profile_update
		user = @current_resource
		if user.merchant
			merchant = user.merchant
			merchant.update_params(params)
		else
			merchant = Merchant.build(params)
			merchant.user = user
		end
		if merchant.save
			render :json => merchant.try(:build_hash).merge(:success => true) || {}
		else
			render :json => {:success => false, :error => merchant.errors.to_a.join(",")}
		end
	end

	def cancel
		refund = Refund.find(params[:id])
		if refund.present?
			hash = refund.cancel
		else
			hash = {:success => false, :error => "Not Found"}
		end		
		render :json => hash
	end

	def get_details
		refund = Refund.find(params[:id])
		render :json => refund.try(:refund_detailed_hash)
	end

	def confirm_account
		refund = Refund.find_by_id(params[:id])
		if refund
			bank_detail = BankDetail.build(params)
			bank_detail.customer_id = refund.try(:customer).try(:id)
			bank_detail.name = refund.customer.try(:name)
			if bank_detail.save
				refund.bank_detail = bank_detail
				refund.save
				render :json => {:success => true}
			else
				render :json => {:success => false, :error => bank_detail.errors.to_a.join(",")}
			end
		else
			render :json => {:success => false, :error => "Invalid Transaction."}
		end

	end

	def confirm_otp
		refund = Refund.find_by_id(params[:id])
		if refund && params[:otp]
			hash = refund.auth_and_bank(params[:otp])
			refund.delete unless hash[:success]
			render :json => hash
		else
			render :json => {:success => false, :error => "Invalid Transaction"}
		end
	end

end