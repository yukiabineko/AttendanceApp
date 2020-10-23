require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "csv import" do
    it 'success' do
      @file = fixture_file_upload('test.csv', 'text/csv')
      #csvのレコード二つ追加
      User.import(@file) 
      expect(User.count).to eq 2
    end
  end
end
