class Picture < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  has_many :user_pictures, dependent: :destroy
end
