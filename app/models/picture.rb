class Picture < ApplicationRecord
  include ImageDestroy
  before_destroy :detail_destroy
  before_validation :text_validation_gsub
  # validates :url, presence: true
  # validates :url, :uniqueness => {:scope => :user_id}

  validates :detail_count, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は一枚以上必要です。' }
  validates :text, length: { maximum: 400 }

  belongs_to :user
  belongs_to :prefecture, optional: true
  counter_culture :prefecture
  belongs_to :municipality, optional: true
  counter_culture :municipality
  has_many :user_pictures, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :picture_details, class_name: 'Pictures::PictureDetail', dependent: :destroy
  accepts_nested_attributes_for :picture_details

  enum gender: { male: 1, female: 2 }
  enum length: { veryshort: 1, short: 2, medium: 3, semilong: 4, long: 5}
  enum color: {brown: 1, yellow: 2, red: 3, black: 4, other: 5}

  scope :area_search, ->(municipalities) {
    if municipalities.present?
      areas = Municipality.where(id: municipalities)
      prefecture = Prefecture.find(areas[0].prefecture_id).name
      prefecture = self.prefecture_ending(prefecture)

      area_params = Array.new
      areas.each do |area|
        s = where('stylists.shop_address like ?', prefecture+area.name+'%')
            .joins(:user => :stylist).references(:user => :stylist).pluck(:id)

        area_params.concat(s)
      end
      
      where(id: area_params)
    end
  }

  scope :length_search, ->(length) {
    if length.present?
      where(length: length)
    end
  }

  scope :gender_search, ->(gender) {
    if gender.present?
      where(gender: gender)
    end
  }

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  def self.prefecture_ending(prefecture)
    if prefecture == '東京'
      return prefecture+'都'
    elsif prefecture == '大阪' || prefecture == '京都'
      return prefecture+'府'
    elsif prefecture == '北海道'
      return prefecture
    else
      return prefecture+'県'
    end
  end

  private
    def detail_destroy
      self.picture_details.each do |detail|
        picture_destroy(dir: ENV['HAIR_PICTURE_DIR'], picture: detail.name)
      end
    end

    def text_validation_gsub
      self.text = self.text.gsub("\r\n", "\n") if self.text != nil
    end
end
