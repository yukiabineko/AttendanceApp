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
  
end
