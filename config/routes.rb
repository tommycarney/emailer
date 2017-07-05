require 'sidekiq/web'

Rails.application.routes.draw do
  resources :contacts do
    collection { post :import }
  end
  resources :campaigns
  get 'campaigns/:id/preview',  to: 'campaigns#preview'
  get 'campaigns/:id/send',     to: 'campaigns#send_templated_email'
  root to: 'static_pages#home'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
