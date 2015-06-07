RefundApp::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => "dashboard#index"

  get "refunds/show"
  match "refunds/initiate_refund" => 'refunds#initiate_refund'
  match "/validate_otp" => 'refunds#validate_otp'
  match "/get_bank_details" => 'refunds#get_bank_details'
  
  namespace :api do
    namespace :v1 do
      resources :signups do
        collection do
          match "new"
          match "reset_password"
        end
      end
      resources :merchants do 
        collection do
          match "get_transfers"
          match "create_refund"
          match "cancel"
          match "get_details"
          match "confirm_account"
          match "confirm_otp"
          match "get_info"
          match "profile_update"
        end
      end

      resources :transactions do
        collection do
          match "create_txn"
          match "update_txn"
        end
      end

    end
  end
end
