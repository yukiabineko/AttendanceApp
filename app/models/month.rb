class Month < ApplicationRecord
  belongs_to :user
  enum week_permit:{
    inprogress3: 1,
    ok3: 2,
    not3: 3
  }
end
