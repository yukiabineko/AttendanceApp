class AttendancesController < ApplicationController
  before_action :setting, only:[ :edit, :update]
  skip_before_action :verify_authenticity_token, only:[:permit_logs]

  def show
  end

  def edit
  end

  #勤怠ログページ
  def permit_logs
    @user = User.find( params[:user_id] )
    @logs = @user.permit_logs
    @years = @user.log_years 
    @months =@user.log_months
  
  end

  def data
   data = params[:year].to_s + "-" + params[:month].to_s + "-01"
   @first_day = Date.parse(data)
   @last_day = @first_day.end_of_month
   @user = User.find( params[:id] )
   @datas = @user.attendances.where(worked_on: @first_day .. @last_day).where(edit_permit: :inprogress2)
   
  end
 


  def update
    if params_check                                                    #=>helper参照
      attendance_parameter.each do |id, value|
        attendance = Attendance.find id
        if value[:edit_superior_name] == "" && !value[:request_startedtime].blank?
          attendance_parameter.each do |id, item|
            attendance = Attendance.find id
            attendance.update(request_startedtime: item[:request_startedtime], request_finishedtime: item[:request_finishedtime], note: item[:note]) #=>renderで自動入力状態を保つため
          end
          flash.now[:notice] ="申告先を選択してください。"
          render :edit
          return
        end
        attendance.update_attributes(value)
        attendance.update_attributes(edit_permit: :inprogress2)
      end
        redirect_to user_url(@user, params:{first_day: @first_day}),notice: "編集しました。"
    else
      attendance_parameter.each do |id, item|
        attendance = Attendance.find id
        attendance.update(request_startedtime: item[:request_startedtime], request_finishedtime: item[:request_finishedtime], note: item[:note]) #=>renderで自動入力状態を保つため
      end
      flash.now[:notice] ="編集失敗。"
      render :edit
    end  
  end

  #上長残業申請返信処理
  def permit_request
    user = User.find( params[:id] )
    attendance_parameter.each do |id, item|
      if item[:change] == '1'
        attendance = Attendance.find id
        attendance.update_attributes(item)
      end
    end
    redirect_to user_url(@user, params:{first_day: params[:day]}),notice: '申請処理しました。'
  end
  
  

  def set_time
  　message = ''
    @attendance = Attendance.find( params[:id] )
    if @attendance.started_at.nil?
      @attendance.start_time_set
      message = 'おはようございます'
    elsif @attendance.finished_at.nil?
      @attendance.finish_time_set
      message = 'お疲れ様です。'
    end
    redirect_to user_path(@attendance.user),notice: message
  end

  #残業申請処理
  def overtime_update
    @attendance = Attendance.find( params[:id] )
    if overtime_validation == false
      redirect_to user_url(@attendance.user, params:{first_day: @attendance.worked_on}), notice: '終了時間が不正です。'
    else
      if params[:attendance][:superior_name] == ""
        redirect_to user_url(@attendance.user, params:{first_day: @attendance.worked_on}), notice: '申告先を選択してください。'
        return
      end
      if params[:attendance][:tommorow_check] == '1'
        @tomorrow_attendance = @attendance.user.attendances.find_by(worked_on: @attendance.worked_on.tomorrow)
        @tomorrow_attendance.update_attributes(overtime_parameter)
      else  
        @attendance.update_attributes(overtime_parameter)
      end
      redirect_to user_path(@attendance.user, params:{first_day: @attendance.worked_on}),notice: '残業申請しました。'
    end
  end

#勤怠変更処理
def edit_permit
  @user = User.find( params[:id] )
  attendance_parameter.each do |id, item|
    if item[:edit_check] == '1'
      attendance = Attendance.find id
      if item[:edit_permit] == 'ok2'
        s_log = attendance.start_log.to_s
        f_log = attendance.finish_log.to_s
        s_log += ',' + attendance.request_startedtime.strftime("%H:%M")
        f_log += ','+  attendance.request_finishedtime.strftime("%H:%M")
        attendance.update_attributes(
          edit_permit: item[:edit_permit],
          started_at: attendance.request_startedtime,
          finished_at: attendance.request_finishedtime,
          request_startedtime: '',
          request_finishedtime: '',
          start_log: s_log,
          finish_log: f_log
        )
      elsif item[:edit_permit] == 'no2'
        attendance.update_attributes(
          edit_permit: item[:edit_permit],
          request_startedtime: '',
          request_finishedtime: ''
        )
      end
     
    end
  end
  redirect_to user_url(@user, params:{first_day: params[:day]})
end



  

private
  def attendance_parameter
    params.require(:user).permit(attendances:
      [
        :started_at, 
        :finished_at, 
        :note,
        :superior_name,
        :change,
        :permit,
        :request_startedtime,
        :request_finishedtime,
        :edit_superior_name,
        :edit_check,
        :edit_permit
      ]
      )[:attendances]
  end

  def overtime_parameter
    params.require(:attendance).permit(
      :overtime,
      :tommorow_check,
      :work_contents,
      :superior_name,
      :change,
      :permit
    )
  end

  def setting
    @user = User.find( params[:user_id])
    @first_day = Date.parse( params[:worked_on])
    @last_day = @first_day.end_of_month
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
    @superior_name = superior_name
  end
  
  
end
