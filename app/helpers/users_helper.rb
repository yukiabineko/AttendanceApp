module UsersHelper
  def superior_name
    superior_users = User.superior_select
    array =[]
    array.push('')
    superior_users.each do |superior|
      unless current_user.name == superior.name
        array.push(superior.name)
      end 
     
    end
    return array
  end

  #勤怠変更申請中ユーザー名
  def request_user_name
    names = []
    @request_attendances.each do |attendance|
      names << attendance.user
    end
    return names.uniq
  end

  #一ヶ月申請中ユーザー名
  def request_months_users
    names = []
    @request_months.each do |month|
      names << month.user
    end
    return names.uniq
  end


end
