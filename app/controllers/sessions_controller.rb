class SessionsController < ApplicationController
  skip_before_action :login_check
  
  def new
  end

  def create
    user = User.find_by(email: session_parameter[:email])
    if user&.authenticate(session_parameter[:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました。'
      user.admin? ? (redirect_to root_url) : (redirect_to user)
    else  
      flash.now[:notice] = '認証失敗'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: 'ログアウトしました。'
  end
  
  

private
  def session_parameter
    params.require(:session).permit( :email, :password )
  end
  
end
