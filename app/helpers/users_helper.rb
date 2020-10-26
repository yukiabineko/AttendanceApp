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
end
