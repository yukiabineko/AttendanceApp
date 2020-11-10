require 'rails_helper'

describe "Shops", type: :system do
    let!(:userA){FactoryBot.create(:user)}
    let!(:userB){ FactoryBot.create(:user, name: 'abi', email: 'abi@example.com', admin: false) }
    let!(:shop){ FactoryBot.create(:shop) }
  before do
    visit login_path
    fill_in "session[email]",	with: "admin@example.com"
    fill_in "session[password]",	with: "123"  
    click_button 'ログイン'
  end
  #管理者の場合表示される、一般は非表示
  describe "admin or normal access" do
    it "login after view" do
      expect(page).to have_content '拠点情報'  
    end

    it "login after not view" do
      visit login_path
      fill_in "session[email]",	with: "abi@example.com"
      fill_in "session[password]",	with: "123"  
      click_button 'ログイン'
      expect(page).to have_no_content '拠点情報'  
    end
  end
########################################################################################
  describe "new shop",js:true do
    before do
      visit shops_path
      
    end
    #新規登録処理確認
    it "add shop" do
      click_button '拠点情報追加'
      fill_in "shop[number]",	with: 9
      fill_in "shop[name]",	with: "竜王"  
      fill_in "shop[category]",	with: "システム" 
      click_button '送信'
      expect(page).to  have_selector '.alert-success',text: '拠点を追加しました。'
      expect(page).to  have_content '竜王'
      
    end
   #拠点編集
    context "edit" do
      it "view" do
        click_on '修正'
        expect(page).to have_content "[#{shop.name}編集]"
        fill_in "shop[number]",	with: 11
        fill_in "shop[name]",	with: "甲府"  
        fill_in "shop[category]",	with: "システム" 
        click_button '送信'
        expect(page).to  have_selector '.alert-success',text: '拠点を編集しました。'
      end
    end

    #拠点削除
    context "edit" do
      it "view" do
        click_on '修正'
        expect(page).to have_content "[#{shop.name}編集]"
        fill_in "shop[number]",	with: 11
        fill_in "shop[name]",	with: "甲府"  
        fill_in "shop[category]",	with: "システム" 
        click_button '送信'
        expect(page).to  have_selector '.alert-success',text: '拠点を編集しました。'
      end
    end

    context " delete",js:true  do   
      it "success" do
        click_on "削除"
        expect(accept_confirm).to eq "削除しますか？"
        expect(page).to have_selector ".alert-success", text: "拠点を削除しました。"
      end
          
    end
    
    
    
  end
  
end
