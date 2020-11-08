module AttendancesHelper
  def params_check
    flag = []
    attendance_parameter.each do |id, item|
      if item[:request_startedtime].nil? && item[:request_finishedtime].nil? && item[:edit_superior_name].blank?
        next
      elsif item[:request_startedtime].blank? && item[:request_finishedtime].blank? && item[:edit_superior_name].blank?
        next
      elsif item[:request_startedtime] > item[:request_finishedtime]
        flag << false
      elsif item[:request_startedtime].blank? || item[:request_finishedtime].blank?
        flag << false
      else
        flag << true
      end
    end
    return flag.include?(false) ? false : true
  end

  #残業バリデーション計算　
  def overtime_validation
    finish_time = (@attendance.finished_at.hour.to_i * 60) + @attendance.finished_at.min.to_i
    if params[:attendance]["overtime(1i)"].blank?
      return false
    end
    overtime  = (params[:attendance]["overtime(4i)"].to_i) *60 + params[:attendance]["overtime(5i)"].to_i
    comp = overtime - finish_time
    return comp >= 0 ? true : false
  end
  

  #残業時間計算
  def overtime(attendance)
    plan = (attendance.overtime.hour.to_i * 60) + attendance.overtime.min.to_i  
    finish_time = attendance.user.finish_work_time
    finish_array = finish_time.split(':')
    finish = (finish_array[0].to_i * 60) + finish_array[1].to_i  
    format("%.2f",(plan - finish) / 60)
  end

  #申請配列
   def request_array
     ["申請中", "承認", "否認"]
   end

  #csv 出力
  def send_posts_csv(attendances)
    bom = "\uFEFF"
    csv_data = CSV.generate(bom) do |csv|
      header = %w(日付 出勤時間 退勤時間)
      csv << header

      attendances.each do |attendance|
        start = attendance.started_at.strftime("%H:%M") if attendance.started_at.present?
        finish =  attendance.finished_at.strftime("%H:%M") if attendance.finished_at.present?
        values = [
          attendance.worked_on, 
          start,
          finish
        ]
        csv << values
      end

    end
    send_data(csv_data,dispositon: 'attachment', filename: "勤怠.csv")
  end

end
