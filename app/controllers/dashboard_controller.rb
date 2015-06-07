class DashboardController < ActionController::Base
	def index
		render :text => "<html> <center> <h1>RevPay</h1></center> </html>"
	end
end