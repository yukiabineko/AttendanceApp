module AttendancesHelper
  def params_check
    flag = []
    attendance_parameter.each do |id, item|
      if item[:started_at].nil? && item[:finished_at].nil?
        next
      elsif item[:started_at] > item[:finished_at]
        flag << false
      elsif item[:started_at].nil? || item[:finished_at].nil?
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
      return true
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
end
