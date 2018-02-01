class HomesController < ApplicationController
  def index
    @pictures = Picture.all.order(rating: :desc).limit(5).offset(0)
  end
end
