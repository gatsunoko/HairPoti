class Picture < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :picture_url, presence: true, uniqueness: true

  has_many :user_pictures, dependent: :destroy

  scope :area_search, ->(area) {
    if area.present? && area != '全国'
      where('shop_address like ?', area+'%')
    end
  }

  scope :length_search, ->(length) {
    if length.present? && length != 'すべて'
      where('length = ?', length)
    end
  }
end
