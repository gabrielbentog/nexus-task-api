Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/healthz", to: proc { [200, {}, ["OK"]] }

  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    post 'authenticate', to: 'authentication#authenticate'

    resources :users
    resources :projects do
      resources :members, controller: 'project_members', only: [:index, :create, :update, :destroy]
      resources :statuses, controller: 'project_statuses', only: [:index, :create, :update, :destroy]
    end
  end
end
