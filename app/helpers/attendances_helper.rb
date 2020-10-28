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
