require 'rails_helper'

describe "users", type: :system do
  before do
    @user = User.create!(
      name: 'abi', 
      email: 'abi@example.com', 
      password: "123", 
      password_confirmation: "123",
      admin: true
      )
    @user2 = User.create!(
      name: 'abi2', 
      email: 'cat@example.com', 
      password: "123", 
      password_confirmation: "123"
      )
    @user3 = User.create!(
      name: 'pico', 
      email: 'pico@example.com', 
      password: "123", 
      password_confirmation: "123",
      superior: true
      )

      visit login_path
      fill_in "session[email]",	with: "abi@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"

      @first = Date.today.beginning_of_month
      @last = @first.end_of_month
      (@first .. @last).each do |day|
        unless @user.attendances.any?{|attendance| attendance.worked_on == day}
          record = @user.attendances.build(worked_on: day)
          record.save

          record2 = @user2.attendances.build(worked_on: day)
          record2.save

          record3 = @user3.attendances.build(worked_on: day)
          record3.save

        end
      end
    @attendance = @user.attendances.first
    @attendance2 = @user2.attendances.first
    @attendance3 = @user3.attendances.first
  end
  

  #上長であるかでviewの分岐テスト
  describe "superior area check" do
    context "not superior" do
      it "user1 not view" do
        visit user_url @user
        expect(page).to  have_no_content '[所属長承認申請のお知らせ]'
      end
    end
    #上長
    context "user3 superior check " do
      before do
        visit login_path
        fill_in "session[email]",	with: "pico@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
      end
      it "user1 success view" do
        visit user_url @user
        expect(page).to  have_content '[所属長承認申請のお知らせ]'
      end
    end
  end

  #残業申請処理(申請者側)
  describe "overtime",js:true do
    
    it "work_content null" do
      expect(@attendance.work_contents).to eq nil
    end

    context "overtime modal view" do
      before do
        visit user_path(@user)
        click_on "overtime#{@attendance.id}"
      end
      #モーダル内の日確認
      it "day view" do
        expect(page).to have_content @attendance.worked_on.strftime('%m/%d') 
      end
      
       #モーダル内入力による更新明日の日付選択
      it "update" do
        fill_in "attendance[work_contents]",	with: "掃除" 
        check
        click_button '申請する'
        tomorrow = @user.attendances.find_by(worked_on: @attendance.worked_on.tomorrow)
        expect(page).to have_content '掃除'
        expect(tomorrow.work_contents).to eq "掃除" 
      end
    end

      #上長残業申請情報表示
    context "superior request info view" do
      before do
        @attendance3.update_attributes(superior_name: @user3.name)
        visit login_path
        fill_in "session[email]",	with: "pico@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
      end
        #残業申請１件表示
        it "request info view success" do
          expect(page).to have_content "[残業申請承認申請のお知らせ] 1件の残業申請があります。"
        end
    end
    
    

  end
  
  
  
end
