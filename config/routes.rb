Rails.application.routes.draw do
  
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    resources :attendances, param: :worked_on, only:[:edit, :update]  #->勤怠編集画面
    member do
      get :info_edit
      patch :info_update
      get :overtime_confirm_modal
      get :edit_permit_modal
      
    end
    post :import, on: :collection
    get :month_modal, on: :member
    
   
  end

  resources :attendances, only:[:show] do
    resources :users, only:[] do
      get :overtime_modal_open, on: :collection
    end

    member do
      post :set_time
      patch :overtime_update    #=>残業申請アップデート
      patch :permit_request         #=>上長申請返信
      patch :edit_permit        #=>勤怠変更申請アップデート
    end
    
  end
  resources :months, only:[:update] do
    patch :response_superior, on: :member
  end

  root 'users#index'
end
