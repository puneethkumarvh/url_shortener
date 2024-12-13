Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'urls#new'

  resources :urls, only: [:new, :create, :show]

  # Route for redirecting
  get '/:short_url', to: 'urls#redirect', as: :short
  namespace :api do
    namespace :v1 do
      resources :urls, only: [:create]
    end
  end
  
end
