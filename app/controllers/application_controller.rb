class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user_from_token!,:except => [:new,:reset_password,:update_txn,:show,:initiate_refund,:validate_otp,:get_bank_details]

  def authenticate_user_from_token!
    if request.headers["auth-token"]
      @user = User.find_by_authentication_token(request.headers["auth-token"])
      if @user
        @current_resource =  @user
        session[:resource_id] = @user.id
        session[:role_name] = User.name
      else
        head :forbidden
      end
    else
      authenticate_user!
    end
  end

  def load_merchant
  	if @current_resource && @current_resource.try(:merchant)
  		@merchant = @current_resource.try(:merchant)
  	else
  		render :json => {:success => false, :error => "Please fill the profile Details."} and return
  	end
  end
end
