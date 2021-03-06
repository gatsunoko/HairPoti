class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :show_modal, :prev, :next, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :new, :create, :collect_new, :collect_call, :edit, :update, :destroy, :my_point_ranking, :my_histories]
  before_action :is_mine, only: [:edit, :update, :destroy]
  before_action :is_stylist, only: [:new, :create]

  include ImageUpload
  include MunicipalityWhere

  # GET /pictures
  # GET /pictures.json
  def index
    if current_user.admin
      @pictures = Picture.all.order(id: :desc).page(params[:page]).per(24)
    else
      @pictures = Picture.where(user_id: current_user.id).order(id: :desc).page(params[:page]).per(24)
    end
  end

  def search
    @pictures = Picture.where(picture_present: true)
                        .area_search(params[:municipalities])
                        .length_search(params[:length])
                        .gender_search(params[:gender])
                        .order(id: :desc)
                        .includes(:picture_details)
                        .includes(:likes)
                        .page(params[:page]).per(24)
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

  def prev_add
    @picture = params[:prev].present? && params[:prev].to_i != 0 ? Picture.find(params[:prev]) : Picture.none
  end

  def next_add
    @picture = params[:next].present? && params[:next].to_i != 0 ? Picture.find(params[:next]) : Picture.none
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    # raise.params.inspect
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    #写真が一枚でもあるか確認、detail_countが1以上じゃないとvalidationに失敗する。
    @picture.detail_count = 0
    params[:picture_detail].each do |key, value|
      @picture.detail_count += 1 if value[:file].present?
    end
    #住所を確認して、prefecture_idとmunicipality_idを設定する
    if current_user.stylist.shop_address.present?
      @picture.prefecture_id = prefecture_where(current_user.stylist.shop_address)
      prefecture = prefecture_ending(Prefecture.find(@picture.prefecture_id).name) if @picture.prefecture_id.present?
      @picture.municipality_id = municipality_where(current_user.stylist.shop_address, prefecture) if @picture.prefecture_id.present?
    end

    respond_to do |format|
      if @picture.save
        params[:picture_detail].each_with_index do |(key, value), i|
          if value[:file].present?
            picture_name = picture_up(file: params[:picture_detail][key][:file],
                                      picture_id: @picture.id,
                                      name: value[:genre],
                                      dir: ENV['HAIR_PICTURE_DIR'],
                                      num: i)
            Pictures::PictureDetail.create(name: picture_name,
                                            user_id: current_user.id,
                                            picture_id: @picture.id,
                                            genre: value[:genre])
          end
        end

        redirect_to root_path and return
      else
        render 'new' and return
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
    redirect_to user_path(current_user.id) and return
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
      params.require(:picture).permit(:length, :color, :text, :gender)
    end
end
