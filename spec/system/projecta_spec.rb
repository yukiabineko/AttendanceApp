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
  describe "csv import" do
   
    let(:csv_file) { 'test.csv' }

    it 'success' do
      post :import, params: {
        csv_file: fixture_file_upload(csv_file, 'text/csv')
      }
      expect(response).to be_successful
    end
  end
end