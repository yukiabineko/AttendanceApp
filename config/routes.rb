Rails.application.routes.draw do
  
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
  end

  resources :attendances do
    post :set_time, on: :member
  end
  root 'users#index'
end
