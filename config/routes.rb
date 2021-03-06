require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'static_pages#home'

  resources :campaigns do
    get  :preview, on: :member, as: :preview_campaign
    post  :send, on: :member, to: 'campaigns#send_templated_email', as: :send_campaign
    resources :contacts do
      get :upload, on: :collection
      post :import, on: :collection
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
