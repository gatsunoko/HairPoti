class HomesController < ApplicationController
  def index
    @ranking = Picture.all.where(picture_present: true).order(rating: :desc).limit(9).offset(0)
    @pictures = Picture.all.where(picture_present: true).order(created_at: :desc).page(params[:page]).per(6)

    #投票フォームのデフォルト値セット
    if session[:area_default].present?
      @area_default = session[:area_default]
    else
      @area_default = '全国'
    end

    if session[:length_default].present?
      @length_default = session[:length_default]
    else
      @length_default = Array.new
    end
  end

  def after_signup
  end
end
