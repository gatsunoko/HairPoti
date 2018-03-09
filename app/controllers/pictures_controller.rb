class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :show_modal, :prev, :next, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :new, :create, :bulk_new, :bulk_create, :collect_new, :collect_call, :edit, :update, :destroy, :my_point_ranking, :my_histories]
  before_action :is_mine, only: [:edit, :update, :destroy]
  before_action :is_admin, only: [:bulk_new, :bulk_create]

  # GET /pictures
  # GET /pictures.json
  def index
    if current_user.admin
      @pictures = Picture.all.order(id: :desc).page(params[:page]).per(12)
    else
      @pictures = Picture.where(user_id: current_user.id).order(id: :desc).page(params[:page]).per(12)
    end
  end

  def search
    @pictures = Picture.where(picture_present: true).area_search(params[:area]).length_search(params[:length]).page(params[:page]).per(12)
    # if browser.device.mobile?
    #   render 'homes/mobile_index' and return
    # else
    #   render 'homes/index' and return
    # end
    render 'homes/index' and return
  end
  
  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  def show_modal
    @next_picture = Picture.find(params[:next_id]) if params[:next_id].present?
    @prev_picture = Picture.find(params[:prev_id]) if params[:prev_id].present?
    render action: 'show', layout: 'modal_picture'
  end

  def next_picture
    @next_picture = params[:next].present? ? Picture.find(params[:next]) : Picture.none
    @prev_picture = params[:prev].present? ? Picture.find(params[:prev]) : Picture.none
  end

  def prev_add
    @picture = params[:prev].present? && params[:prev].to_i != 0 ? Picture.find(params[:prev]) : Picture.none
  end

  def next_add
    @picture = params[:next].present? && params[:next].to_i != 0 ? Picture.find(params[:next]) : Picture.none
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
    @picture.build_picture_option if current_user.admin?
  end

  # GET /pictures/1/edit
  def edit
    @picture.build_picture_option if current_user.admin? && @picture.picture_option.blank?
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)
    @picture.url.sub!(/\?.*/, "")
    @picture.user_id = current_user.id

    respond_to do |format|
      if @picture.save
        format.html { redirect_to pictures_path, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def bulk_new
  end

  def bulk_create
    #raise.params.inspect
    urls = params[:urls]
    urls = urls.gsub(/\r\n|\r|\n/, ",")#改行をカンマに変更
    urls = urls.split(",")#ひとつの文字列だったspをカンマで区切って配列にする
    @success = 0 #登録の成功した数をカウントする変数
    @fail = 0 #登録の失敗した数をカウントする変数

    urls.each do |url|
      url.sub!(/\?.*/, "")
      picture = Picture.new(url: url, user_id: current_user.id, length: params[:length])
      picture.build_picture_option(name: params[:name], profile: params[:profile], shop_name: params[:shop_name], shop_address: params[:shop_address], shop_phone_number: params[:shop_phone_number]) if current_user.admin?
      if picture.save
        @success += 1 
      else
        @fail += 1
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    redirect_to pictures_path
    # respond_to do |format|
    #   format.html { redirect_back(fallback_location: root_path) } and return
    #   format.json { head :no_content }
    # end
  end

  def short_ranking
    pictures_array = Picture.where('length = ? OR length = ?', 'ショート', 'ベリーショート').order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(rating: :desc).page(params[:page]).per(10)
    render 'ranking'
  end

  def midiamu_ranking
    pictures_array = Picture.where('length = ?', 'ミディアム').order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(rating: :desc).limit(100).offset(0).page(params[:page]).per(10)
    render 'ranking'
  end

  def long_ranking
    pictures_array = Picture.where('length = ? OR length = ?', 'ロング', 'セミロング').order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(rating: :desc).page(params[:page]).per(10)
    render 'ranking'
  end

  def my_histories
    pictures_array = UserPicture.where(user_id: current_user.id).where('win > ?', 0).order(voting_at: :desc).limit(100).offset(0).pluck(:id)
    @pictures = UserPicture.where(id: pictures_array).order(voting_at: :desc).page(params[:page]).per(10).includes(:picture)
    render 'ranking'
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def is_mine
      if @picture.user_id != current_user.id && current_user.admin == false
        redirect_back(fallback_location: root_path) and return
      end
    end

    def picture_params
      params.require(:picture).permit(:url, :length, :color, picture_option_attributes: [:id, :destroy, :name, :profile, :shop_name, :shop_address, :shop_phone_number])
    end
end
