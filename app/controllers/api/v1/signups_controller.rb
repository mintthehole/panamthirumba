class Api::V1::SignupsController < ApplicationController
	respond_to :xml, :json
	def new
		rand = Random.new.rand(0..1)
		user = User.find_by_email(params[:email])
		if rand == 0
			render :json => {:success => true, :authToken =>"123" }
		else
			render :json => {:success => false, :errors => "Account Already Exists"}
		end
	end

	def reset_password
		if true
			render :json => {:success => true}
		else
			render :json => {:success => false, :errors => "Email doesn't Exist"}
		end
	end

end