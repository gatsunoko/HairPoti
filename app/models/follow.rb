class Follow < ApplicationRecord
  belongs_to :stylist, class_name: 'User'
  counter_culture :stylist, column_name: 'follower_count'
  belongs_to :user, class_name: 'User'
  counter_culture :user, column_name: 'follows_count'
end