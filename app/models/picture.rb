class Picture < ApplicationRecord
  validates :url, presence: true
  validates :url, :uniqueness => {:scope => :user_id}

  belongs_to :user
  has_many :user_pictures, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :picture_option, class_name: 'Admin::PictureOption', dependent: :destroy
  accepts_nested_attributes_for :picture_option

  scope :area_search, ->(area) {
    if area.present? && area != '全国'
      where('stylists.shop_address like ? OR admin_picture_options.shop_address like ?', area+'%', area+'%')
        .joins(:user => :stylist).references(:user => :stylist)
        .joins(:picture_option).references(:picture_option)
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
