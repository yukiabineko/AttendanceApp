class ApplicationController < ActionController::Base
  
  helper_method :current_user
  before_action :login_check
  include AttendancesHelper
  include UsersHelper
  protect_from_forgery

  def current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_check
    redirect_to login_path unless current_user.present?
  end

  #管理者以外アクセス不可ユーザーページに戻る
  def admin_check
    redirect_to current_user,notice: '管理者専用です。' unless current_user.admin?
  end
  
end
