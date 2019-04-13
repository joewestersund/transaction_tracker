Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

 resources :transfers
 get '/transfers/:id/copy', to: 'transfers#copy', as: 'copy_transfer'

 resources :account_balances

 get "/check_balance", to: 'balance_checks#check_balance'

 get "/summaries/by_account"
 get "/summaries/by_category"
 get "/summaries/by_transaction_direction"

 get '/about', to: 'static_pages#about' # creates named path 'about'
 get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'
 get '/signup', to: 'users#new' # creates named path 'signup'

 resources :users
 get '/profile/edit_password', to: 'users#edit_password'
 get '/profile/edit', to: 'users#edit'
 patch '/profile/update_password', to: 'users#update_password'

 resources :transactions
 get '/transactions/:id/copy', to: 'transactions#copy', as: 'copy_transaction'

 resources :transaction_categories
 post '/transaction_categories/:id/move_up', to: 'transaction_categories#move_up'
 post '/transaction_categories/:id/move_down', to: 'transaction_categories#move_down'

 resources :accounts
 post '/accounts/:id/move_up', to: 'accounts#move_up'
 post '/accounts/:id/move_down', to: 'accounts#move_down'

 resources :sessions, only: [:new, :create, :destroy]
 get '/signin', to: "sessions#new"
 delete '/signout', to: "sessions#destroy"

 root 'static_pages#about'

end
