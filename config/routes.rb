Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/about', to: 'static_pages#about' # creates named path 'about'
  get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'
  get '/signup', to: 'users#new' # creates named path 'signup'

  resources :users, except: [:show, :destroy]
  resources :user_groups

  get '/profile/edit_password', to: 'users#edit_password'
  get '/profile/edit', to: 'users#edit_profile'

  patch '/profile/update_password', to: 'users#update_password'
  patch '/profile/update', to: 'users#update_profile'


  get '/password/forgot', to: 'users#forgot_password'
  post '/password/send_reset_email', to: 'users#send_password_reset_email'
  get '/password/resend_activation_email', to: 'users#activate', as: :activate
  post '/password/resend_activation_email', to: 'users#resend_activation_email'
  get '/password/reset/:token', to: 'users#reset_password'
  get '/activate_account/:token', to: 'users#reset_password'

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  delete '/signout', to: "sessions#destroy"

  get '/about', to: 'static_pages#about' # creates named path 'about'
  get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'

  root 'static_pages#about'

  ## TRANSACTION ROUTES
  resources :repeating_transfers
  resources :repeating_transactions

  resources :transfers
  get '/transfers/:id/copy', to: 'transfers#copy', as: 'copy_transfer'

  resources :account_balances

  get "/check_balance", to: 'balance_checks#check_balance'

  get "/transaction_summaries/by_account"
  get "/transaction_summaries/by_category"
  get "/transaction_summaries/by_transaction_direction"

  resources :transactions
  get '/transactions/:id/copy', to: 'transactions#copy', as: 'copy_transaction'

  resources :transaction_categories
  post '/transaction_categories/:id/move_up', to: 'transaction_categories#move_up'
  post '/transaction_categories/:id/move_down', to: 'transaction_categories#move_down'

  resources :accounts
  post '/accounts/:id/move_up', to: 'accounts#move_up'
  post '/accounts/:id/move_down', to: 'accounts#move_down'

  ### WORKOUT ROUTEs
  resources :default_data_points, except: :show
  resources :workouts, except: :show

  resources :workout_types, except: :show, shallow: true do
    resources :routes, except: :show, shallow: true do
      resources :default_data_points, except: :show
    end
    resources :data_types, except: :show, shallow: true do
      resources :dropdown_options, except: :show
      resources :data_points, except: :show
    end
  end

  post '/workout_types/:id/move_up', to: 'workout_types#move_up', as: :move_workout_type_up
  post '/workout_types/:id/move_down', to: 'workout_types#move_down', as: :move_workout_type_down

  get '/routes', to: 'routes#default_index', as: :routes_default  # show routes for the first workout type
  get '/data_types', to: 'data_types#default_index', as: :data_types_default  # show dts for the first workout type

  post '/routes/:id/move_up', to: 'routes#move_up', as: :move_route_up
  post '/routes/:id/move_down', to: 'routes#move_down', as: :move_route_down

  post '/dropdown_options/:id/move_up', to: 'dropdown_options#move_up', as: :move_dropdown_option_up
  post '/dropdown_options/:id/move_down', to: 'dropdown_options#move_down', as: :move_dropdown_option_down

  post '/data_types/:id/move_up', to: 'data_types#move_up', as: :move_data_type_up
  post '/data_types/:id/move_down', to: 'data_types#move_down', as: :move_data_type_down

  get "/workout_summaries/time_series"
  get "/workout_summaries/x_vs_y"

end