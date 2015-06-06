class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user_from_token!,:except => [:new,:reset_password]

  def authenticate_user_from_token!
    if request.headers["auth-token"]
      @user = User.find_by_authentication_token(request.headers["auth-token"])
      if @user
        @current_resource =  @user.merchant
        session[:resource_id] = @user.id
        session[:role_name] = User.name
      else
        head :forbidden
      end
    else
      authenticate_user!
    end
  end
end
