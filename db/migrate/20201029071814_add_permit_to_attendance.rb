class AddPermitToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :change, :boolean, default: false
    add_column :attendances, :permit, :integer, default: 0
  end
end
