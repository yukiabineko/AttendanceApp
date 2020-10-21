class AddSuperiorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :integer
    add_column :users, :basic_work_time, :string
    add_column :users, :superior, :boolean, default: false
  end
end
