class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_check

  def current_user
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_check
    redirect_to login_path unless current_user.present?
  end
  
end
