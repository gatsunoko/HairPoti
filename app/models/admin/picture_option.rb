class Admin::PictureOption < ApplicationRecord
  validates :profile, length: { maximum: 1000 }
end
