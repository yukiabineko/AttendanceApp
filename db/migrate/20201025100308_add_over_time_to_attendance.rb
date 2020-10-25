class AddOverTimeToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :overtime, :datetime
    add_column :attendances, :tommorow_check, :boolean, default: false
    add_column :attendances, :work_contents, :string
    add_column :attendances, :superior_name, :string
  end
end
