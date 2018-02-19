FactoryGirl.define do
  factory :user do
    sequence(:email, 1) {|n|"example#{n}@email.com"}
    role 2
    sequence(:name, 1) {|n|"#{n}太郎"}
    profile 'profile'
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
end