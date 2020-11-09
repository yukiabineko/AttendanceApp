FactoryBot.define do
    factory :user do
      name{"管理者"}
      email{"admin@example.com"}
      password {"123"}
      password_confirmation{"123"}
      admin {true}
      superior{false}
    end
  end