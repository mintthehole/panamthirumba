class Api::V1::SignupsController < ApplicationController
	respond_to :xml, :json
	def new
		user = User.find_by_email(params[:email])
		if user
			unless user.valid_password?(params[:password])
				render :json => {:success => false, :errors => "Wrong Email / Password."} and return
			end
		else
			user = User.create(:email => params[:email],:password => params[:password])
		end
		render :json => {:success => true, :authToken =>user.authentication_token }
	end

	def reset_password
		if true
			render :json => {:success => true}
		else
			render :json => {:success => false, :errors => "Email doesn't Exist"}
		end
	end

end