class Picture < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  belongs_to :user
  has_many :user_pictures, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :area_search, ->(area) {
    if area.present? && area != '全国'
      where('shop_address like ?', area+'%')
    end
  }

  scope :length_search, ->(length) {
    if length.present?
      where(length: length)
    end
  }

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
end
