class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:follows]

  def index
    @ranking = Picture.where(picture_present: true).includes(:picture_details).order(id: :desc).limit(9).offset(0)
    @pictures = Picture.where(picture_present: true).where.not('id IN (?)', @ranking.pluck(:id)).includes(:picture_details).order(id: :desc).page(params[:page]).per(24)

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

    # if browser.device.mobile?
    #   render 'mobile_index' and return
    # else
    #   render 'index' and return
    # end
    render 'homes/index' and return
  end

  def follows
    follows = Follow.where(user_id: current_user.id).pluck(:stylist_id)
    @pictures = Picture.where(picture_present: true)
                        .where(user_id: follows)
                        .includes(:picture_details)
                        .order(id: :desc)
                        .page(params[:page])
                        .per(24)

    render 'homes/index' and return
  end

  def after_signup
  end
end
