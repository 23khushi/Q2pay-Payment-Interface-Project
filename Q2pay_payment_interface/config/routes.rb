Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users 
  resources :accounts
  resources :transactions
  post 'accounts/:id/add_money', to: 'accounts#add_money'
  # get "/users/:aadhar_no", to: "users#show"
  # get "/users/:pan_no", to: "users#show"

end
