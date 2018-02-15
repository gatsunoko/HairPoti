FactoryGirl.define do
  factory :picture do
    sequence(:url, 1) {|n|"https://test.com#{n}"}
    sequence(:picture_url, 1) {|n|"https://test.com#{n}"}
    user_id 1
  end
end
