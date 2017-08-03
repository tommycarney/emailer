require 'sidekiq/web'

Rails.application.routes.draw do
  resources :contacts
  resources :campaigns do
    post :import, on: :member
  end

  get 'campaigns/:id/preview',  to: 'campaigns#preview', as: :preview_campaign
  get 'campaigns/:id/send',     to: 'campaigns#send_templated_email', as: :send_campaign
  root to: 'static_pages#home'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
