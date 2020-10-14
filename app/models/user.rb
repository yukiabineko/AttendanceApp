class User < ApplicationRecord
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
  

  
  
  
end
