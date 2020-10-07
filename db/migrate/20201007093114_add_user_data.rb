class AddUserData < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email, :string
    add_column :users, :password_digest, :string
    change_column :users, :email, :string, null:false
    change_column :users, :password_digest, :string, null:false
  end
end
