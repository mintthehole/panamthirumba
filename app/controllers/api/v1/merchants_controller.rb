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
				if refund.customer_in_store
					flag = refund.aadhaar_verfication
					error = "Invalid Aadhaar Number" unless flag
				end
				render :json => {:success => flag, :error => error}
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

	end

	def confirm_account

	end

	def confirm_otp
		cus = Customer.find_by_aadhaar_no(params[:aadhaar_no])
		if cus && params[:otp]
			
			render :json => {:success => true, :has_account => true}
		else
			render :json => {:success => false, :error => "Aadhaar Number not found."}
		end
	end

end