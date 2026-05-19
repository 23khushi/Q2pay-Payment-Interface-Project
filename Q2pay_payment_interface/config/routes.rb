Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users 

  #user login
  post '/users/login/', to: 'users#login'

  #user aadhar verification
  post '/users/aadhar-verification', to: 'users#verify_aadhar'

  resources :accounts

  # create transaction 
  post '/transactions', to: 'payments#create'

  #get transactions
  get '/transactions', to: 'payments#index'

end
