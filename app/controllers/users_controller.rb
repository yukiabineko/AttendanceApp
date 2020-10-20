class UsersController < ApplicationController
  before_action :user_set, only: [ :edit, :update, :destroy]
  before_action :admin_check, only: [:index, :info_edit]
  before_action :other_user_access, only: [:show]

  def index
    @users = User.all
  end

  def new
   @user = User.new
  end

  def create
    @user = User.new(user_parameter)
    if @user.save
      redirect_to @user, notice: "#{@user.name}を登録しました。"
    else  
      render :new
    end
    
  end

  def edit
  end

  def show
    @user = User.find( params[:id] )
    if params[:first_day].nil?
      @first_day = Date.today.beginning_of_month
    else
      @first_day = Date.parse( params[:first_day])
    end
   
    @last_day = @first_day.end_of_month
    (@first_day .. @last_day).each do |day|
      unless @user.attendances.any?{|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
    @work_count = @user.attendances.work_count                           #-> modelより
    
  end

  def update
    if @user.update_attributes(user_parameter)
      redirect_to @user, notice: "#{@user.name}を編集しました。"
    else  
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, notice: "削除しました。"
  else  
  end

#管理者による追加情報登録ページ
  def info_edit
    @user = User.find( params[:id] )
  end


private
  def user_parameter
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_set
    @user = User.find( params[:id] )
  end

  #管理者以外アクセス不可ユーザーページに戻る
  def admin_check
    redirect_to current_user,notice: '管理者専用です。' unless current_user.admin?
  end

   #管理者以外URLで他のユーザーのページアクセス禁止
   def other_user_access
    user  = User.find( params[:id])
     if  user.id  != current_user.id
      unless current_user.admin?
        redirect_to current_user,notice: '不正な操作です。'
      end
     end
   end
  

  
  
  
end
