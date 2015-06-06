class RefundLink < ActiveRecord::Base
  attr_accessible :is_valid, :link, :no_of_attempts
end
