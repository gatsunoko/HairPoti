FactoryGirl.define do
  factory :picture do
    sequence(:url, 1) {|n|"https://www.instagram.com/p/1111111111#{n}"}
    user_id 1
  end
end
