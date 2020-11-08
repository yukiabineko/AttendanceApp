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
        end
      end

      (@first .. @last).each do |day|
        unless @user2.attendances.any?{|attendance| attendance.worked_on == day}
          record2 = @user2.attendances.build(worked_on: day)
          record2.save
        end
      end

      (@first .. @last).each do |day|
        unless @user3.attendances.any?{|attendance| attendance.worked_on == day}
          record3 = @user2.attendances.build(worked_on: day)
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
        expect(page).to  have_content '[残業申請承認申請のお知らせ]'
      end
    end
  end
##############################################################################################
  #残業申請処理(申請者側)
  describe "overtime",js:true do
    #出退勤入力
    before do
      @attendance.update_attributes(
        started_at: "2020-03-04 01:00:00 +0900",
        finished_at: "2020-03-04 09:00:00 +0900"
      )
    end
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
        select(value = @user3.name, from: "attendance[superior_name]")
        select(value = "21", from: "attendance[overtime(4i)]") 
        select(value = "00", from: "attendance[overtime(5i)]") 
        check
        click_button '申請する'
        tomorrow = @user.attendances.find_by(worked_on: @attendance.worked_on.tomorrow)
        expect(page).to have_content '掃除'
        expect(tomorrow.work_contents).to eq "掃除" 
        expect(page).to  have_content 'picoに残業申請中'
      end
      

       #残業時間不正入力チェック
      it "check overtime" do
         fill_in "attendance[work_contents]",	with: "掃除" 
         select(value = "01", from: "attendance[overtime(4i)]") 
         select(value = "00", from: "attendance[overtime(5i)]") 
         click_button '申請する'
         expect(page).to  have_content '終了時間が不正です。'
      end
      
    end

      #上長残業申請情報表示
    context "superior request info view" do
      before do
        @attendance2.update_attributes(superior_name: @user3.name, permit: 1)
        visit login_path
        fill_in "session[email]",	with: "pico@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
      end
        #残業申請１件表示
        it "request info view success" do
          expect(page).to have_content "[残業申請承認申請のお知らせ] 1件の残業申請があります。"
        end
        #変更にチェックいれ、承認を選択
        it "superior action" do
          @attendance2.update_attributes(change: true, permit: 2)
          visit login_path
          fill_in "session[email]",	with: "cat@example.com" 
          fill_in "session[password]",	with: "123" 
          click_button "ログイン"
          expect(page).to  have_content 'picoから残業承認済み'
        end
    end
  end
########################################################################################################################
  ########  勤怠編集処理 申請者 ###############################
  describe "edit_attendance" do
    #出退勤入力
    before do
      @attendance2.update_attributes(
        started_at: "2020-03-04 01:00:00 +0900",
        finished_at: "2020-03-04 09:00:00 +0900"
      )
      visit login_path
      fill_in "session[email]",	with: "cat@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"
    end
    #ユーザー申告
    context "user request" do
      before do
       

        visit edit_user_attendance_path(@user2, @attendance2.worked_on)
        fill_in "user[attendances][#{@attendance2.id}][request_startedtime]", with: "12:00"
        fill_in "user[attendances][#{@attendance2.id}][request_finishedtime]", with: "15:00"
        select(value = @user3.name, from: "user[attendances][#{@attendance2.id}][edit_superior_name]") 
        click_button "編集"

      end
      it "request success" do
        expect(page).to have_content "編集しました。" 
      end

       #上長側確認、処理
      it "superior permit" do
        visit login_path
        fill_in "session[email]",	with: "pico@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
         #申請がある
         expect(page).to  have_content "[勤怠変更申請のお知らせ] 1件の勤怠変更申請があります。"
      end
      
    end 
  end
##############################################################################################################  
   ########  勤怠編集処理上長 ###############################
   describe "edit_attendance",js:true do
    #出退勤入力
    before do
      @attendance2.update_attributes(
        started_at: "2020-03-04 01:00:00 +0900",
        finished_at: "2020-03-04 09:00:00 +0900",
        request_startedtime:"2020-03-04 12:00:00 +0900",
        request_finishedtime:"2020-03-04 15:00:00 +0900",
        edit_superior_name: @user3.name,
        edit_permit:"inprogress2"
      )
      visit login_path
        fill_in "session[email]",	with: "pico@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
    end
    it "view" do
      expect(page).to  have_content "[勤怠変更申請のお知らせ] 1件の勤怠変更申請があります。"
    end

   it "modal view" do
     click_on "1件の勤怠変更申請があります。"
     expect(page).to  have_content "[abi2からの勤怠変更申請]"
   end

   #上長承認後、承認済みを確認
   it "modal view" do
    click_on "1件の勤怠変更申請があります。"
    check
    select(value = "承認済み", from: "user[attendances][#{@attendance2.id}][edit_permit]") 
    click_on '変更を送信する'

    visit login_path
    fill_in "session[email]",	with: "cat@example.com" 
    fill_in "session[password]",	with: "123" 
    click_button "ログイン"
    expect(page).to  have_content "#{@user3.name}から変更承認済み"
   end
  end
########################################################################################  
    ######勤怠ログ#######################################
describe "attendance log", js:true do
  before do
    @attendance2.update_attributes(
      worked_on: "2020-03-04",
      started_at: "2020-03-04 01:00:00 +0900",
      finished_at: "2020-03-04 09:00:00 +0900",
      request_startedtime:"",
      request_finishedtime:"",
      edit_superior_name: @user3.name,
      edit_permit:"ok2",
      start_log: ",1:00,4:00,3:00",
      finish_log: ",5:00,9:00,12:00"
    )
    visit login_path
    fill_in "session[email]",	with: "cat@example.com" 
    fill_in "session[password]",	with: "123" 
    click_button "ログイン"

   
  end

    it "view page" do
      visit permit_logs_user_attendances_path(@user2)
      expect(page).to have_content 'データがありません'
    end

    #年、月選択後データ表示
    context "year month select" do
      it "select year month" do
        visit permit_logs_user_attendances_path(@user2)
        select(value = "2020", from: "year_select") 
        select(value = "3", from: "month_select") 
        expect(page).to have_content 'pico'
        expect(page).to have_no_content 'データがありません' #->これは表示されなくなる。
      end
    end

    #リセットボタン
    context "reset button" do
      it "reset success" do
        visit permit_logs_user_attendances_path(@user2)
        click_on 'リセット'
        expect(page).to have_no_content 'pico'        #->これは表示されなくなる。
        expect(page).to have_content 'データがありません' 
      end
    end
    
end
###########################################################################################################
describe "attendance csv"  do
  before do
    @attendance2.update_attributes(
      worked_on: "2020-03-04",
      started_at: "2020-03-04 01:00:00 +0900",
      finished_at: "2020-03-04 09:00:00 +0900",
      request_startedtime:"",
      request_finishedtime:"",
      edit_superior_name: @user3.name,
      edit_permit:"ok2",
      start_log: ",1:00,4:00,3:00",
      finish_log: ",5:00,9:00,12:00"
    )
    visit login_path
    fill_in "session[email]",	with: "cat@example.com" 
    fill_in "session[password]",	with: "123" 
    click_button "ログイン"
  end
    #csvボタン
    context "csv button" do
      it "reset success" do
        click_on 'CSV出力'
        expect(page.response_headers['Content-Disposition']).to include('勤怠.csv')
      end
    end   
end  
######################################################################################## 
end
