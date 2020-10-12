class UsersController < ApplicationController
  before_action :user_set, only: [ :edit, :update, :show, :destroy]

  def index
    @users = User.all
  end

  def new
   @user = User.new
  end

  def create
    @user = User.new(user_parameter)
    if @user.save
      redirect_to root_url, notice: "#{@user.name}を登録しました。"
    else  
      render :new
    end
    
  end

  def edit
  end

  def show
    @first_day = Date.today.beginning_of_month
    @last_day = @first_day.end_of_month
    (@first_day .. @last_day).each do |day|
      unless @user.attendances.any?{|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
    
  end

  def update
    if @user.update_attributes(user_parameter)
      redirect_to root_url, notice: "#{@user.name}を編集しました。"
    else  
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, notice: "削除しました。"
  else  
  end

  def time_set
    debugger
  end
  
  
  
private
  def user_parameter
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_set
    @user = User.find( params[:id] )
  end
  
  
end
