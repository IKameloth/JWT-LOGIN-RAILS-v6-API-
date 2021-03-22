Rails.application.routes.draw do
  # namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    resources :notes
    resource :users, only: [:create]
    post "/login", to: "users#login"
  # end
end
