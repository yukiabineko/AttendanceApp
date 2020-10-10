require 'rails_helper'

describe "sessions", type: :system  do
  before do
    @user = User.create!(
      name: 'snake',
      email: 'snake@example.com',
      password: '123',
      password_confirmation: '123'
    )
  end
  
  describe "login" do
    context "login page move" do
      it "success" do
        visit login_path
        fill_in "session[email]",	with: "snake@example.com" 
        fill_in "session[password]",	with: "123" 
        click_button "ログイン"
        expect(page).to  have_content "ログアウト"
      end
      
      it "failure" do
        visit login_path
        fill_in "session[email]",	with: "snake@example.com" 
        fill_in "session[password]",	with: "1" 
        click_button "ログイン"
        expect(page).to  have_selector ".alert-success", text: "認証失敗"
      end
    end

    describe "logout" do
     it "success" do
      visit login_path
      fill_in "session[email]",	with: "snake@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"

      click_on "ログアウト"
      expect(page).to  have_content "ログアウト"
     end
     
    end
    
    
  end
  
end
