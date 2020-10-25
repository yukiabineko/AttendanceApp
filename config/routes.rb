Rails.application.routes.draw do
  
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    resources :attendances, param: :worked_on, only:[:edit, :update]  #->勤怠編集画面
    member do
      get :info_edit
      patch :info_update
     
    end
    post :import, on: :collection
   
  end

  resources :attendances, only:[:show] do
    resources :users do
      get :overtime_modal_open, on: :collection
    end

    member do
      post :set_time
      patch :overtime_update    #=>残業申請アップデート
    end
  end
  root 'users#index'
end
