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
  
  
  
end
