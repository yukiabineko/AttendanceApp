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

end
