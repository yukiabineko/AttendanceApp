module UsersHelper
  def superior_name
    superior_users = User.superior_select
    array =[]
    superior_users.each do |superior|
      unless current_user.name == superior.name
        array.push(superior.name)
      end 
     
    end
    return array
  end
  #申請中ユーザー名
  def request_user_name
    names = []
    @request_attendances.each do |attendance|
      names << attendance.user
    end
    return names.uniq
  end
end
