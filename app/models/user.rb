class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :build_default_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :likes
  has_one :stylist

  enum role: { user: 1, stylist: 2, admin: 3 }

  private
    def build_default_profile
      if self.role == 'stylist'
        build_stylist
        true
      end
    end
end
