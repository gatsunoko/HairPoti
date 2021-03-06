class User < ApplicationRecord
  include ImageDestroy
  before_destroy :profile_picture_destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :build_default_profile
  before_validation :profile_validation_gsub

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  validates :profile, length: { maximum: 1000 }

  has_many :likes, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :follower, class_name: 'Follow', foreign_key: 'stylist_id', dependent: :destroy
  has_many :follows, class_name: 'Follow', foreign_key: 'user_id', dependent: :destroy
  has_one :stylist, dependent: :destroy
  accepts_nested_attributes_for :stylist

  enum role: { user: 1, stylist: 2, admin: 3 }

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
 
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        image: auth.info.image,
        name: auth.info.name,
        nickname: auth.info.nickname,
        location: auth.info.location,
        confirmed_at: Date.today
      )
    end
 
    user
  end

  def self.find_for_google(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    unless user
      user = User.create(name:     'ユーザーネーム未設定',
                         provider: auth.provider,
                         email:    User.dummy_email(auth),
                         uid:      auth.uid,
                         token:    auth.credentials.token,
                         password: Devise.friendly_token[0, 20],
                         confirmed_at: Date.today)
    end
    user
  end

  def follow_user(user_id)
    return follower.exists?(user_id: user_id)
  end

  private
    def build_default_profile
      if self.role == 'stylist'
        build_stylist
        true
      end
    end

    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@omniauthable.com"
    end

    def profile_picture_destroy
      if self.picture.present?
        picture_destroy(dir: ENV['PROFILE_PICTURE_DIR'], picture: self.picture)
      end
    end

    def profile_validation_gsub
      self.profile = self.profile.gsub("\r\n", "\n") if self.profile != nil
    end
end