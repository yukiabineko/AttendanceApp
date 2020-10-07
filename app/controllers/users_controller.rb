class UsersController < ApplicationController
  before_action :user_set, only: [ :edit, :update, :show, :destroy]

  def index
    @users = User.all
  end

  def new

  end

  def edit
  end

  def show
  end
private
  def user_parameter
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_set
    @user = User.find( params[:id] )
  end
  
  
end
