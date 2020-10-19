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
      redirect_to @user, notice: "#{@user.name}を登録しました。"
    else  
      render :new
    end
    
  end

  def edit
  end

  def show
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


private
  def user_parameter
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_set
    @user = User.find( params[:id] )
  end
  
  
end
