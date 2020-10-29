class Attendance < ApplicationRecord
  belongs_to :user
  enum permit:{
    non: 0,
    inprogress: 1,
    ok: 2,
    not: 3
  }

  #出勤時間

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

  #退勤時間

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
  #日別合計時間計算

  def day_total_time
      start_time = (self.started_at.hour.to_i * 60) + self.started_at.min.to_i
      finish_time = (self.finished_at.hour.to_i * 60) + self.finished_at.min.to_i
      format("%.2f",(finish_time -start_time) / 60)
  end
  
  #出勤日数
  scope :work_count, -> { where.not(finished_at: nil).count}
 
  #残業申請されているattendance
  scope :user_request, ->(user) { where(superior_name: user.name)}
  
  
  
 
end
