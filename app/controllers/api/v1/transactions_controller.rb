class Api::V1::TransactionsController < ApplicationController
	respond_to :xml, :json
	def create_txn
		refund = Refund.find(params[:id])
		if refund
			bill = refund.generate_bill("http://"+request.host_with_port)
			p bill
			render :json => {:success => true, :bill => bill}
		else
			render :json => {:success => false, :error => "Invalid Transaction"}
		end
	end

	def update_txn
		verification_data = params['TxId']+params['TxStatus']+params['amount']+params['pgTxnNo']+params['issuerRefNo']+params['authIdCode']+params['firstName']+params['lastName']+params['pgRespCode']+params['addressZip'] rescue ''
		signature = BankApi.get_signature(verification_data)
		if signature == params[:signature]
			txn = Transaction.find_by_id(params[:TxId].to_i)
			if txn.present? && params[:TxStatus] == "SUCCESS"
			  txn.update_attributes(:status => Transaction::COMPLETED,:txn_ref_no => params[:TxRefNo])
			  @hash = {:TxStatus => "SUCCESS", :id => txn.try(:refund_id)}
			elsif txn.blank?
			  @hash = {:TxStatus =>"FAIL",:reason => "Transaction Not Found."}
			else
			  @hash = {:TxStatus =>"FAIL",:reason => params[:TxMsg]}
			end
		else
			@hash = {:TxStatus => "ERROR",:reason => "Signature Verfication Failed"}
		end
		render "layouts/payment_response", :layout => false
	end
end