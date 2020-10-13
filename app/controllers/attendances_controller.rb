class AttendancesController < ApplicationController

  def show
  end

  def edit
    @user = User.find( params[:user_id])
    @first_day = Date.parse( params[:worked_on])
    @last_day = @first_day.end_of_month
    @days = @user.searchDay(@first_day, @last_day)
    @week = %w(日 月 火 水 木 金 土)
    
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
end
