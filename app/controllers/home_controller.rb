class HomeController < ApplicationController
  def index
  	p "poll"
  	p request.url
  end
end
