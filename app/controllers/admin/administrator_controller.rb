class Admin::AdministratorController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin

  def index
  end

  def blank_pictures
    @pictures = Picture.where(picture_present: false).order(updated_at: :desc).page(params[:page]).per(20)
    render 'pictures/index'
  end

  def multiple_urls
    @pictures = Picture.group(:url).having('count(*) >= 2').order(id: :desc).page(params[:page]).per(20)
  end

  def multiple_url
    url = Picture.find params[:id]
    @pictures = Picture.where('url = ?', url.url)
  end

  def image_present
    begin
      @picture = Picture.find(params[:id])
      @picture.picture_present = @picture.picture_present ? false : true
      @picture.save
    rescue

    end
  end
end