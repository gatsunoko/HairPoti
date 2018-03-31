FactoryBot.define do
  factory :user do
    sequence(:email, 1) {|n|"user#{n}@email.com"}
    role 1
    admin false
    sequence(:name, 1) {|n|"#{n}太郎"}
    profile 'profile'
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
end