Rails.application.routes.draw do
  resources :contacts
  resources :campaigns
  root to: 'static_pages#home'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
