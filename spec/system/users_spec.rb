require 'rails_helper'

describe "users", type: :system do
  before do
    @user = User.create!(
      name: 'abi', 
      email: 'abi@example.com', 
      password: "123", 
      password_confirmation: "123"
      )
  end
  describe "user index view" do
    it "@user.name present" do
      visit root_path
      expect(page).to have_content 'abi'
    end
    
  end
  
end
