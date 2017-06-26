Rails.application.routes.draw do
  resources :contacts do
    collection { post :import }
  end
  resources :campaigns do
    member do
      get 'preview'
      get 'send'
    end
  end
  root to: 'static_pages#home'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
