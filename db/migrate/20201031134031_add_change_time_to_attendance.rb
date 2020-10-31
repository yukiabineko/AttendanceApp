class AddChangeTimeToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :request_startedtime, :datetime
    add_column :attendances, :request_finishedtime, :datetime
    add_column :attendances, :edit_superior_name, :string
    add_column :attendances, :edit_permit, :integer, default: 0
  end
end
