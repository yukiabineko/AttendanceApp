Rails.application.routes.draw do
  

  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :shops

  resources :users do
    resources :attendances, param: :worked_on, only:[:edit, :update] do  #->勤怠編集画面
      get :permit_logs, on: :collection                                          #->勤怠ログ
      post :permit_logs, on: :collection
    end
    member do
      get :info_edit
      patch :info_update
      get :overtime_confirm_modal
      get :edit_permit_modal
      get :month_modal
    end
    collection do
      post :import
      get :apis
    end
   
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
    get :working, on: :collection  #=>出勤社員
  end

  post '/data/:id',to: 'attendances#data', as: :data_post
  resources :months, only:[:update] do
    patch :response_superior, on: :member
  end

  root 'users#index'
end
