require 'rails_helper'

describe "users",type: :system do
  before do
    @user = User.create!(
      name: 'abi', 
      email: 'abi@example.com', 
      password: "123", 
      password_confirmation: "123"
      )
      visit login_path
      fill_in "session[email]",	with: "abi@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"
  end
  describe "user index view" do
    it "user.name present" do
      expect(page).to have_content 'abi'
    end
  end
  describe "user record new",js:true do
    it "success" do
      visit new_user_path
      fill_in "user[name]",	with: "abi" 
      fill_in "user[email]",	with: "abi2@example.com"
      fill_in "user[password]",	with: "123" 
      fill_in "user[password_confirmation]",	with: "123" 
      click_on "登録する"
      expect(page).to  have_selector ".alert-success", text: "abiを登録しました。"
    end
  end

  describe "user search ane edit" do
    context "user find" do
      it "find success" do
        visit edit_user_path @user
        expect(page).to have_content "abi" 
      end
    end

    context "edit user" do
      it "success" do
        visit edit_user_path @user
        fill_in "user[name]",	with: "abi2" 
        fill_in "user[email]",	with: "abi3@example.com"
        fill_in "user[password]",	with: "123" 
        fill_in "user[password_confirmation]",	with: "123" 
        click_on "更新する"
        expect(page).to  have_selector ".alert-success", text: "abi2を編集しました。"
      end
    end
  end

  describe "item delete" do
    context "delete" do
      it "success" do
        visit root_path
        click_on "del#{@user.id}"
        expect(accept_confirm).to eq "削除しますか？"
        expect(page).to have_selector ".alert-success", text: "削除しました。"
      end
      
    end
    
  end

  
  
  
end
