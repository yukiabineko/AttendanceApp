class Month < ApplicationRecord
  validates :superior_name, presence: true, allow_nil: true
  belongs_to :user
  enum month_permit:{
    inprogress3: 1,
    ok3: 2,
    not3: 3
  }
end
