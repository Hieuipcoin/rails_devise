Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {registrations: "registrations", sessions: 'sessions', confirmations: 'confirmations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :refresh_tokens
end
