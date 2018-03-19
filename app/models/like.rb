class Like < ApplicationRecord
  belongs_to :picture
  counter_culture :picture
end
