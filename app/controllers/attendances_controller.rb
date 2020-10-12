class AttendancesController < ApplicationController
  def show
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
