class Month < ApplicationRecord
  validates :superior_name, presence: true, allow_nil: true
  belongs_to :user
  enum month_permit:{
    inprogress3: 1,
    ok3: 2,
    not3: 3
  }
   #1ｶ月変更申請されている month
   scope :month_request, ->(user) { where(superior_name: user.name).where(permit_month: 1)}
 
end
