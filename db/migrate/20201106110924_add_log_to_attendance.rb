class AddLogToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :start_log, :text
    add_column :attendances, :finish_log, :text
  end
end
