Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resource :user, only: [:show, :edit, :update, :new, :create]

  resources :restaurants, only: [:index, :edit, :update]

  resource :home, only: [:show]

  resource :sms, only: [:create]

  authenticated :user do
    root to: 'restaurants#index', as: :authenticated_root
  end

  unauthenticated :user do
    root to: 'homes#show', as: :unauthenticated_root
  end
end
