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
    context "suceess date" do
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

    context "name Error" do
      it "name validate" do
        user = User.new(
          name: '',
          email: 'abi@example.com',
          password: '123',
          password_confirmation: '123'
        )
        user.valid?
        expect(user.errors.full_messages).to  include("名前を入力してください")
      end
    end

    context "email unless present Error" do
      it "success" do
        user = User.new(
          name: 'abio',
          email: '',
          password: '123',
          password_confirmation: '123'
        )
        user.valid?
        expect(user.errors.full_messages).to  include("メールアドレスを入力してください")
      end
    end

    context "password unless present Error" do
      it "success" do
        user = User.new(
          name: 'abio',
          email: 'exx@example.com',
          password: '',
          password_confirmation: '123'
        )
        user.valid?
        expect(user.errors.full_messages).to  include("パスワードを入力してください")
      end
    end

    context "email unique Error" do
      it "email Error check" do
        user = User.create(
          name: "pico",
          email: "poco@example.com",
          password: "123",
          password_confirmation: "123"
        )
        user.valid?
        expect(user.errors.full_messages).to include("メールアドレスはすでに存在します")
      end
    end


    context "password difficult  Error" do
      it "success" do
        user = User.create(
          name: "picos",
          email: "pocos@example.com",
          password: "123",
          password_confirmation: "12"
        )
        user.valid?
        expect(user.errors.full_messages).to include("パスワード確認とパスワードの入力が一致しません")
      end
      
    end
  end
#************************************ update ************************************************
  describe "user update check" do
    it "success" do
      @user.update_attributes(
        name: 'pico2',
        email: "pico2@example.com"
      )
      expect(@user).to be_valid 
    end 

    context "name unless present" do
      it "success" do
        @user.update_attributes(
          name: "",
          email: "tests@email.com",
          password: "123",
          password_confirmation: "123"
        )
        @user.valid?
        expect(@user.errors.full_messages).to  include("名前を入力してください")
      end
    end

    context "email unless present" do
      it "success" do
        @user.update_attributes(
          name: "test",
          email: "",
          password: "123",
          password_confirmation: "123"
        )
        @user.valid?
        expect(@user.errors.full_messages).to  include("メールアドレスを入力してください")
      end
    end

    context "email unique Error" do
      it "email Error check" do
        user = User.new(
          name: 'abi',
          email: 'abi@example.com',
          password: '123',
          password_confirmation: '123'
        )
        user.update_attributes(
          name: "pico",
          email: "poco@example.com",
          password: "123",
          password_confirmation: "123"
        )
        user.valid?
        expect(user.errors.full_messages).to include("メールアドレスはすでに存在します")
      end
    end

    context "password difficult  Error" do
      it "success" do
        @user.update_attributes(
          name: "picos",
          email: "pocos@example.com",
          password: "123",
          password_confirmation: "12"
        )
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード確認とパスワードの入力が一致しません")
      end
    end
  end

  

  
end
