require 'rails_helper'

RSpec.describe Attendance, type: :model do
  #first setting 
  before do
   @user = User.create!(
      name: 'dog',
      email: 'dog@example.com',
      password: '123',
      password_confirmation: '123'
    )
    @first = Date.today.beginning_of_month
    @last = @first.end_of_month
    (@first .. @last).each do |day|
      unless @user.attendances.any?{|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @attendances = Attendance.all
  end

##############################################################################
  describe "record confirm" do
    it "show record" do
      today = Date.today
      attend = Attendance.find_by(worked_on: today)
      expect(attend.user_id).to eq(@user.id)
      expect(attend.worked_on).to eq(today)
    end
  end

  #日付ごとの合計時間
  
  describe "day_total check" do
    it "success" do
      attend = @attendances.first
      attend.update_attributes(started_at: '2020-10-14 08:00', finished_at: '2020-10-14 10:00')
      att = @attendances.first
      day_total = att.day_total_time
      expect(day_total).to eq("2.00")
    end
    
  end
  

end
