require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.create(
      name: 'poco',
      email: 'poco@example.com',
      password: '123',
      password_confirmation: '123'
    )
  end
  describe "user record add" do
    it "suceess" do
      user = User.new(
        name: 'abi',
        email: 'abi@example.com',
        password: '123',
        password_confirmation: '123'
      )
      expect(user).to be_valid
    end
  end

  describe "user update check" do
    it "success" do
      @user.update_attributes(
        name: 'pico2',
        email: "pico2@example.com"
      )
      expect(@user).to be_valid 
    end 
  end
  
  
end
