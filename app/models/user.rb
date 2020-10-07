class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true,allow_blank: true
  validates :password_confirmation, presence: true,allow_blank: true
  
end
