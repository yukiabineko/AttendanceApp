class Month < ApplicationRecord
  validates :superior_name, presence: true, allow_nil: true
  belongs_to :user
  enum permit_month:{
    inprogress3: 1,
    ok3: 2,
    not3: 3
  }
   #1ｶ月変更申請されている month
   scope :month_request, ->(user) { where(superior_name: user.name).where(permit_month: :inprogress3)}

   def month_status
    case self.permit_month
    when 0
      return '未'
    when "inprogress3"
      return "#{self.superior_name}に申請中" if self.superior_name.present?
    when "ok3"
      return "#{self.superior_name}から承認済み" if self.superior_name.present?
    when "not3"
      return "#{self.superior_name}から否認済み" if self.superior_name.present?
    else
      return '未'
    end  
   end
 
end
