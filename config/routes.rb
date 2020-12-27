Rails.application.routes.draw do
  
  get 'password_resets/edit'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get "/terms", to: "static_pages#terms"
  get '/signup', to: 'users#new'
  
  get '/login', to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts, only:[:create, :new, :show, :destroy]
  resources :comments, only:[:create]
  resources :password_resets, only:[:edit, :update]
  resources :relationships, only:[:create, :destroy]
end