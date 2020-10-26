class User < ApplicationRecord
  require 'csv'
  has_secure_password
  has_many :attendances, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true,allow_blank: true
  validates :password_confirmation, presence: true,allow_blank: true

  def searchDay(first, last)
    self.attendances.where(worked_on: first .. last).order(id: :ASC)
  end


  #月合計稼働時間

  def month_total(monthData)
    total = 0.0
    monthData.each do |day|
      if day.started_at.present? && day.finished_at.present?
        total += day.day_total_time.to_i #->attendance model参照 
      end
    end
    return total
  end

  #契約稼働時間計算
  def operating_time_calc
    if self.start_work_time.present? && self.finish_work_time.present?
      start = self.start_work_time
      start_array = start.split(':')
      start_time = (start_array[0].to_i) * 60 + start_array[1].to_i
      
      finish = self.finish_work_time
      finish_array = finish.split(':')
      finish_time = (finish_array[0].to_i) * 60 + finish_array[1].to_i

      operating_time = (finish_time - start_time)/60.to_f
      return operating_time
    else
      return ''
    end
  end

  #csvインポート
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      attendance = find_by(id: row["id"]) || new
      attendance.attributes = row.to_hash.slice(*updatable_attributes)
      attendance.save!
    end
  end

  #csvキー配列
  def self.updatable_attributes
    [
      'name', 
      'email', 
      'password', 
      'password_confirmation', 
      'start_work_time', 
      'finish_work_time',
      'department',
      'employee_number',
      'uid',
      'superior'
    ]
  end
#上長ユーザー
scope :superior_select, -> { where(:superior => true)}
 
#申請済みattendance数

def superior_request_count
  counts = Attendance.where(superior_name: self.name).count
  return counts ==0? 0 : counts
end
  
  
end
