class Picture < ApplicationRecord
  validates :url, uniqueness: true
end
