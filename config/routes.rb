Rails.application.routes.draw do
  post 'login', to: 'authentication#create'        # create the token
  
  get 'employees', to: 'users#index'               # check all employees
  get 'employees/:id', to: 'users#show'            # check specific employee
  post 'signup', to: 'users#create'                # create a user employee
  put 'employees/:id', to: 'users#update'          # update specfic employees info

  get 'access_reports', to: 'access_reports#index' # check the entry and exit of all employes if admin, if not personal reports

  resources :access_reports, only: [:show, :create, :update, :destroy]
end
