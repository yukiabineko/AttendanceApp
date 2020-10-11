Rails.application.routes.draw do
  get 'attendances/show'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  root 'users#index'
end
