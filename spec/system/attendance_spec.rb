require 'rails_helper'

describe "attendances", type: :system  do
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
    
  end

  #ログイン後ユーザー詳細で登録した日付があるか？
  describe "day check" do
    before do
      @attendance = @user.attendances.find_by(worked_on: Date.today)
      visit login_path
      fill_in "session[email]",	with: "dog@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button 'ログイン'
    end

    #登録日付があるかチェック
    context "view check" do
      it "success" do
        expect(page).to have_content (@first + 5).strftime('%m/%d')
      end
    end

    #出勤ボタンで成功確認
    context "start time check" do
      it "success" do
        click_on '出勤'
        expect(page).to have_content '退勤'  #->出勤処理後退勤ボタンがある。
      end
    end

    #退勤ボタンで成功確認
    context "finish time check" do
      it "success" do
        click_on '出勤'
        click_on '退勤'
        expect(page).to have_selector '.alert-success', text:'お疲れ様です。'  #->出勤処理後退勤ボタンが消失する。
      end
    end
    #←ボタンによる月切り替え前月
    context "prev month change" do
      it "success" do
        click_on '←'
        expect(page).to have_content @first.prev_month.strftime('%m月')
      end
    end

    #→ボタンによる月切り替え次月
    context "next month change" do
      it "success" do
        click_on '→'
        expect(page).to have_content @first.next_month.strftime('%m月')
      end
    end
    
  end
  #######################user show 合計関連 #############################################
  describe "total_data_view" do
    before do
      attend = @user.attendances.all
      fs = attend.first
      ls = attend.last
      fs.update_attributes(started_at: '2020-10-12 08:00', finished_at: '2020-10-12 12:00')
      ls.update_attributes(started_at: '2020-10-12 08:00', finished_at: '2020-10-12 12:00')
      visit login_path
      fill_in "session[email]",	with: "dog@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button 'ログイン'
    end

    #出勤日数
    context "work count" do
      it "day count success" do
        @user.attendances.work_count
        expect(page).to have_content '2日'
      end
      
    end

    #出勤時間総数
    context "work month total time" do
      it "month total time success" do
        days = @user.searchDay(@first, @last)
        @user.month_total(days)
        expect(page).to have_content '8.0'
      end
      
    end
  end
  
end
