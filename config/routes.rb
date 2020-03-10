Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'login', to: 'authentication#create'
  post 'signup', to: 'users#create'

  get 'access_reports', to: 'access_reports#index'
  get 'employees/:id', to: 'users#show'
  put 'employees/:id', to: 'users#update'
  get 'employees', to: 'users#index'

  resources :users
  resources :access_reports
end
