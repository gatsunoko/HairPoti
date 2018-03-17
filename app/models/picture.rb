class Picture < ApplicationRecord
  # validates :url, presence: true
  # validates :url, :uniqueness => {:scope => :user_id}
  validates :detail_count, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は一枚以上必要です。' }

  belongs_to :user
  has_many :user_pictures, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :picture_option, class_name: 'Admin::PictureOption', dependent: :destroy
  has_many :picture_details, class_name: 'Pictures::PictureDetail', dependent: :destroy
  accepts_nested_attributes_for :picture_option
  accepts_nested_attributes_for :picture_details

  scope :area_search, ->(area) {
    if area.present? && area != '全国'
      s = where('stylists.shop_address like ?', area+'%')
          .joins(:user => :stylist).references(:user => :stylist).pluck(:id)

      a = where('admin_picture_options.shop_address like ?', area+'%')
          .joins(:picture_option).references(:picture_option).pluck(:id)

      s.concat(a)
      where(id: s)
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
