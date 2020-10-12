class Attendance < ApplicationRecord
  belongs_to :user

  def start_time_set
    self.started_at = Time.new(
        Time.now.year,
        Time.now.month,
        Time.now.day,
        Time.now.hour,
        Time.now.min, 0
      )
    self.save
  end

  def finish_time_set
    self.finished_at = Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
    self.save
  end
  
end
