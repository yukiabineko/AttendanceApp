class UsersController < ApplicationController
  before_action :user_set, only: [ :edit, :update, :destroy, :show, :month_modal]
  before_action :admin_check, only: [:index, :info_edit]
  before_action :other_user_access, only: [:show]
  skip_before_action :login_check, only: [ :apis ] 

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
      @first_day = Date.parse( params[:first_day]).beginning_of_month
    end
   
    @last_day = @first_day.end_of_month
    (@first_day .. @last_day).each do |day|
      unless @user.attendances.any?{|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    #月データ作成
    month = @user.months.where(request_month: @first_day.strftime('%m月')).where(year: @first_day.strftime('%Y')) 
    if month.count == 0 
      record = @user.months.build(
        request_month: @first_day.strftime('%m月'),
         year: @first_day.strftime('%Y'),
         base_day: @first_day
      )
      record.save
    end
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
    @work_count = @user.attendances.work_count                           #-> modelより
    @overtime_request_count = @user.superior_request_count               #->残業申請数
    @month_count = @user.month_request_count                             #->1ヶ月申請数
    @edit_request_count = @user.edit_attendance_request_count
    @superior_name = superior_name  #=>ヘルパーメゾット
    @month = @user.months.find_by(request_month: @first_day.strftime('%m月') , year: @first_day.strftime('%Y'))
    respond_to do |format|
      format.html do
         
      end 
      format.csv do
        send_posts_csv(@days)
      end
    end
  end

  def update
    if @user.update_attributes(user_parameter)
      flash[:notice] = "#{@user.name}を編集しました。"
      current_user.admin? ? (redirect_to root_url) : (redirect_to @user)
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

#管理者による追加情報更新処理
  def info_update
    @user = User.find( params[:id] )
    if @userupdate_attribu.tes(user_parameter)
      redirect_to root_url, notice: "#{@user.name}の契約内容を更新しました。"
    else
      flash.now[:notice] = '失敗しました。'
      render :info_edit
    end
  end

#csvにてインポート
  def import
    @users = User.all
    CSV.foreach(params[:file].path, headers: true) do |row|
      user = User.find_by(id: row["id"]) || User.new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save!
    end
    respond_to do |format|
      flash.now[:notice] = "インポートしました。"
      format.html { render :index }
    end
  end
  
  #残業申請ボタン押しした時モーダル
  def overtime_modal_open
    @attendance = Attendance.find( params[:attendance_id] )
    @week = %w(日 月 火 水 木 金 土)
    @superior_name = superior_name  #=>ヘルパーメゾット
    
  end
  
  #残業申請上長許可処理
  def overtime_confirm_modal
    @user = User.find( params[:id] )
    @week = %w(日 月 火 水 木 金 土)
    @request_attendances = Attendance.user_request(@user)
    @request_users = request_user_name       #=>helperより
  end
  
  #勤怠変更モーダル
  def edit_permit_modal
    @user = User.find( params[:id] )
    @week = %w(日 月 火 水 木 金 土)
    @request_attendances = Attendance.edit_request(@user)
    @request_users = request_user_name       #=>helperより
  end

  #一ヶ月申請モーダル
  def month_modal
    @request_months = Month.month_request(@user)
    @request_users = request_months_users
  end
  
 #api処理
 def apis
  @users = User.all
   render json: @users
 end

 #フロントエンドからユーザー送信登録
 def api_new
   if params{
     debugger
   }
 end

private
  def user_parameter
    params.require(:user).permit(
      :name, 
      :email, 
      :password, 
      :password_confirmation, 
      :department, 
      :start_work_time,
      :finish_work_time,
      :employee_number,
      :uid
    )
  end

  def user_set
    @user = User.find( params[:id] )
  end

  #管理者以外アクセス不可ユーザーページに戻る
  def admin_check
    redirect_to current_user,notice: '管理者専用です。' unless current_user.admin?
  end

   #管理者、上長以外URLで他のユーザーのページアクセス禁止
   def other_user_access
    user  = User.find( params[:id])
     if  user.id  != current_user.id
      unless (current_user.admin? || current_user.superior)
        redirect_to current_user,notice: '不正な操作です。'
      end
     end
   end

  
  
   def updatable_attributes
    [
      'name', 
      'email', 
      'password', 
      'password_confirmation', 
      'start_work_time', 
      'finish_work_time',
      'department',
      'employee_number',
      'uid',
      'superior'
    ]
  end
  
  
  
  
end
