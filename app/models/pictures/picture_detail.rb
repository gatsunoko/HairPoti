class Pictures::PictureDetail < ApplicationRecord
  enum genre: {picture_front: 1, picture_side: 2, picture_back: 3, overroll: 4}
end
