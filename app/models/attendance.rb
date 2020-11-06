class Attendance < ApplicationRecord
  belongs_to :user
  enum permit:{
    inprogress: 1,
    ok: 2,
    not: 3
  }
  enum edit_permit:{
    inprogress2: 1,
    ok2: 2,
    not2: 3
  }

  #出勤時間

  def start_time_set
    time = Time.new(
        Time.now.year,
        Time.now.month,
        Time.now.day,
        Time.now.hour,
        Time.now.min, 0
      )
    self.started_at =time
    log = self.start_log.to_s
    log += "," + time.strftime("%H:%M")
    self.start_log = log
    self.save

  end

  #退勤時間

  def finish_time_set
    time = Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
    self.finished_at = time
    log = self.finish_log.to_s
    log += "," + time.strftime("%H:%M")
    self.finish_log = log
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

  #勤怠変更申請されている attendance
  scope :edit_request, ->(user) { where(edit_superior_name: user.name).where(edit_permit: :inprogress2)}
 
  
  
  #enumによる分岐
  def enum_check
    case self.permit
    when 0
      return ''
    when "inprogress"
      return "#{self.superior_name}に残業申請中" if self.superior_name.present?
    when 'ok'
      return "#{self.superior_name}から残業承認済み" if self.superior_name.present?
    when 'not'
      return "#{self.superior_name}から残業否認済み" if self.superior_name.present?
    else
    end  
  end

  #enum勤怠編集編集による分岐
  def edit_enum_check
    case self.edit_permit
    when 0
      return ''
    when "inprogress2"
      return "#{self.edit_superior_name}に変更申請中" if self.edit_superior_name.present?
    when 'ok2'
      return "#{self.edit_superior_name}から変更承認済み" if self.edit_superior_name.present?
    when 'not2'
      return "#{self.edit_superior_name}から変更否認済み" if self.edit_superior_name.present?
    else
    end  
  end
  
 
end
