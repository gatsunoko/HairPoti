class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :build_default_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  validates :profile, length: { maximum: 1000 }

  has_many :likes, dependent: :destroy
  has_many :pictures, dependent: :destroy
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
end