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

      visit login_path
      fill_in "session[email]",	with: "abi@example.com" 
      fill_in "session[password]",	with: "123" 
      click_button "ログイン"
  end
#****************************************************************************************************
  describe "user index view" do
    it "user.name present" do
      expect(page).to have_content 'abi'
      expect(page).to have_content '従業員一覧'
     
    end
    #従業員一覧
    context "users index page" do
      it "admin user not link" do
        visit root_path
        userA = User.first
        userB = User.last
         #管理者のためボタンが表示されない(削除idで検証)
        expect(page).to have_no_selector('#del1')
         #一般従業員のためボタンが表示される(削除idで検証)
        expect(page).to have_selector('#del2')
      end
    end
  #管理ユーザーのため従業員契約ページURLでへアクセス可
  context "link info edit" do
    it "success" do
      visit info_edit_user_path(@user2)
      expect(page).to  have_content "#{@user2.name}契約情報入力"
    end
  end

  #管理者のため他の従業員の勤怠ページアクセス可能
  context "other user page access" do
    it "success" do
      visit user_path(@user2)
      expect(page).to  have_content "#{@user2.name}詳細"
    end
  end
    
end
#*************************************************************************************************************
  describe "user record new" do
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
        visit edit_user_path @user2
        expect(page).to have_content "abi2" 
      end
    end

    context "edit user" do
      it "success" do
        visit edit_user_path @user2
        fill_in "user[name]",	with: "abi2" 
        fill_in "user[email]",	with: "abi3@example.com"
        fill_in "user[password]",	with: "1234" 
        fill_in "user[password_confirmation]",	with: "1234" 
        click_on "更新する"
        expect(page).to  have_selector ".alert-success", text: "abi2を編集しました。"
      end
    end
  end

=begin

  describe "item delete",js:true  do    #ローカルではこのテスト通るがcircleciでは失敗するため調査中
    it "success" do
      visit root_path
      click_on "del#{@user.id}"
      expect(accept_confirm).to eq "削除しますか？"
      expect(page).to have_selector ".alert-success", text: "削除しました。"
    end
        
  end
=end 

#管理権限がないユーザーでアクセス*******************************************************************

describe "not admin user" do
  before do
    logout_path   #->管理者ログアウト
    visit login_path
    fill_in "session[email]",	with: "cat@example.com" 
    fill_in "session[password]",	with: "123" 
    click_button "ログイン"
  end
  #ヘッダーに従業員一覧がない
  context "header null users_path link" do
    it "success" do
      expect(page).to  have_no_content '従業員一覧'
    end
  end

  #一般ユーザーのため従業員一覧へアクセス不可
  context "header null users_path link" do
    it "success" do
      visit root_path
      expect(page).to  have_no_content '会員一覧'
    end
  end

  #一般ユーザーのため従業員契約ページへアクセス不可
  context "header null users_path link" do
    it "success" do
      visit info_edit_user_path(@user2)
      expect(page).to  have_no_content "#{@user2.name}契約情報入力"
    end
  end

  #一般ユーザーのため従業員契約ページURLでへアクセス可
  context "link info edit" do
    it "success" do
      visit info_edit_user_path(@user)
      expect(page).to  have_selector ".alert-success", text:"管理者専用です。"
    end
  end
 end
 #****************************************************************************** 
 
end
