Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/confirm_email/:token', to: 'auth#confirm_email', as: 'auth_confirm_email_path'
  
  resources :users, only: [:index, :create, :show]
end
