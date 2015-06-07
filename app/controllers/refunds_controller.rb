class RefundsController < ApplicationController
  def show
  	@succes = false
  	@msg = ''
  	@refund = Refund.find_by_id(params[:id])
  	if @refund && @refund.state == Refund::INITIATED && @refund.try(:refund_link)
  		refund_link = @refund.try(:refund_link)
  		if refund_link.try(:no_of_attempts).to_i < 4
  			refund_link.no_of_attempts += 1
  			refund_link.save
  			@succes = true
  		else
  			@msg = "No. of attempts exceeded. Please contact the merchant. #{@refund.merchant.try(:name)}"
  		end
  	else
  		merchant_name = @refund.merchant.name rescue 'name'
  		@msg = "Transaction is Invalid. Please contact the Merchant - #{merchant_name}"
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
  		@hash = @refund.auth_and_bank(params[:otp].to_i)
    else
      @hash = {:success => false ,:error => "Invalid Transaction"}
  	end
  end

  def get_bank_details
    @refund = Refund.find_by_id(params[:id])
    if @refund
      bank_detail = BankDetail.build(params)
      bank_detail.customer_id = @refund.try(:customer).try(:id)
      bank_detail.name = @refund.customer.try(:name)
      if bank_detail.save
        @refund.bank_detail = bank_detail
        @refund.save
        @hash =  {:success => true, :msg => "Merchant will refund to the provided Bank Account. Thank You.(This is illustrative. Don't expect Payment)"}
      else
        @hash = {:success => false, :msg => bank_detail.errors.to_a.join(",")}
      end
    else
      @hash = {:success => false, :msg => "Invalid Transaction."}
    end
  end

end
