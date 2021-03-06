class BaseResource < ActiveResource::Base
	BaseResource.site = Settings.remote_url
	class << self
	  def headers
	    strata_headers = {"AUTH-TOKEN" => "polaijm12inusu@#",
	                      "Content-Type" => "application/json"}
	    if defined?(@headers)
	      @headers.merge! strata_headers
	    elsif superclass != Object && superclass.headers
	      superclass.headers.merge! strata_headers
	    else
	      @headers ||= strata_headers
	    end
	  end
	end
end