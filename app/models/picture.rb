class Picture < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :picture_url, presence: true, uniqueness: true

  has_many :user_pictures, dependent: :destroy

  scope :area_search, ->(area) {  
    where('shop_address like ?', area+'%') if area.present?
  }
end
