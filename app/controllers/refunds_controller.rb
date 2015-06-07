class RefundsController < ApplicationController
  def show
  	@succes = false
  	@msg = ''
  	@refund = Refund.find_by_id(params[:id])
  	if @refund && @refund.state == Refund::INITIATED
  		refund_link = @refund.refund_link
  		if refund_link.no_of_attempts < 40 
  			refund_link.no_of_attempts += 1
  			refund_link.save
  			@succes = true
  		else
  			@msg = "No. of attempts exceeded. Please contact the merchant. #{@refund.merchant.try(:name)}"
  		end
  	else
  		merchant_name = @refund.merchant.name rescue 'name'
  		@msg = "Transaction as already been initiated, and it is in #{@refund.state}. Please contact the merchant. #{merchant_name}"
  	end
  end

  def initiate_refund
  	@refund = Refund.find_by_id(params[:refund]["id"].to_i)
  	if @refund && @refund.state == Refund::INITIATED && @refund.refund_link.no_of_attempts < 40
  		@hash = @refund.customer.send_otp
  	end
  end

  def validate_otp
  	@refund = Refund.find_by_id(params[:id].to_i)
  	if @refund
  		p @hash = @refund.auth_and_bank(params[:otp].to_i)
  	end
  end

end
