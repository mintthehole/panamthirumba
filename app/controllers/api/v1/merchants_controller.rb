class Api::V1::MerchantsController < ApplicationController
	respond_to :xml, :json
	def get_transfers
	end

	def create_refund

	end

	def get_info
		render :json => @current_resource.try(:merchant).try(:build_hash) || {}
	end

	def profile_update
		user = @current_resource
		merchant = Merchant.build(params)
		merchant.user = user
		if merchant.save
			render :json => @current_resource.try(:merchant).try(:build_hash).merge(:sucess => true) || {}
		else
			render :json => {:sucess => false, :error => merchant.errors.to_a.join(",")}
		end
	end

	def cancel
		refund = Refund.find(params[:id])
		if refund.present?
			hash = refund.cancel
		else
			hash = {:sucess => false, :error => "Not Found"}
		end		
		render :json => hash
	end

	def get_details

	end

	def confirm_account

	end

	def confirm_otp

	end

end