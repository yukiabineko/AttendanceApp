class AttendancesController < ApplicationController
  before_action :setting, only:[ :edit, :update]

  def show
  end

  def edit
  end


  def update
    if params_check                                                    #=>helper参照
      attendance_parameter.each do |id, value|
        attendance = Attendance.find id
        attendance.update_attributes(value)
      end
        redirect_to user_url(@user, params:{first_day: @first_day}),notice: "編集しました。"
    else
      attendance_parameter.each do |id, item|
        attendance = Attendance.find id
        attendance.update(started_at: item[:started_at], finished_at: item[:finished_at], note: item[:note])
      end
      flash.now[:notice] ="編集失敗。"
      render :edit
    end  
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
    if params[:attendance][:tommorow_check] == '1'
      @tomorrow_attendance = @attendance.user.attendances.find_by(worked_on: @attendance.worked_on.tomorrow)
      @tomorrow_attendance.update_attributes(overtime_parameter)
    else  
      @attendance.update_attributes(overtime_parameter)
    end
    redirect_to user_path(@attendance.user, params:{first_day: @attendance.worked_on})
  end
  




private
  def attendance_parameter
    params.require(:user).permit(attendances:[:started_at, :finished_at, :note])[:attendances]
  end

  def overtime_parameter
    params.require(:attendance).permit(
      :overtime,
      :tommorow_check,
      :work_contents,
      :superior_name
    )
  end

  def setting
    @user = User.find( params[:user_id])
    @first_day = Date.parse( params[:worked_on])
    @last_day = @first_day.end_of_month
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
  end
  
  
end
