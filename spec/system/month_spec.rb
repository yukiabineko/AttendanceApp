require 'rails_helper'

describe "Month",type: :system do
  before do
    @first_day = Date.today.beginning_of_month
    @userA = User.create!(
      name: 'abi', 
      email: 'abi@example.com', 
      password: "123", 
      password_confirmation: "123",
      superior: true
    )
    @userB = User.create!(
      name: 'cat', 
      email: 'cat@example.com', 
      password: "123", 
      password_confirmation: "123",
    )
    month = @userB.months.find_by(request_month: @first_day.strftime('%m月'),year: @first_day.strftime('%Y')) 
    if month.nil?
      record = @userB.months.build(
        request_month: @first_day.strftime('%m月'),
         year: @first_day.strftime('%Y'),
         base_day: @first_day
      )
      record.save
    end
    @month = @userB.months.find_by(request_month: @first_day.strftime('%m月'),year: @first_day.strftime('%Y')) 
  end

######################################################################################################################
   describe "month request" do
    before do
      visit login_path
      fill_in "session[email]",	with: "cat@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"

    end
    #フォームが表示され未認証確認
     context "view form" do
       it "success" do
         expect(page).to  have_content '所属長承認 未'
       end
     end
     #上長申請
     context "request" do
       before do
        select(value = @userA.name, from: "month[superior_name]")
        click_button "申請"
       end
       #申請済み表示に変わる。
       it "success" do
        expect(page).to  have_content '所属長承認 abiに申請中'
       end
       
     end
     
   end
####################################################################################################################   

end
