module UsersHelper
  def superior_name
    superior_users = User.superior_select
    array =[]
    superior_users.each do |superior|
      array.push(superior.name)
    end
    return array
  end
end
