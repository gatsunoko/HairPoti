class Picture < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :picture_url, presence: true, uniqueness: true

  has_many :user_pictures, dependent: :destroy

  scope :area_search, ->(area) {  
    where('shop_address like ?', area+'%') if area.present?
  }

  scope :length_search, ->(length) {
    if length.present? && length != 'すべて'
      where('length = ?', length)
    end
  }
end
