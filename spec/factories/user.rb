FactoryGirl.define do
  factory :user do
    sequence(:email, 1) {|n|"example#{n}@email.com"}
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
end