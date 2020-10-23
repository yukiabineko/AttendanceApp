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
  
  
end
