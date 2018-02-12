require 'open-uri' # URLにアクセスするためのライブラリの読み込み
require 'nokogiri' # Nokogiriライブラリの読み込み

class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :new, :create, :bulk_new, :bulk_create, :collect_new, :collect_call, :edit, :update, :destroy, :my_point_ranking, :my_histories]
  before_action :is_admin, only: [:edit, :update, :destroy, :blank_pictures, :collect_new, :collect_call]

  # GET /pictures
  # GET /pictures.json
  def index
    if current_user.admin
      @pictures = Picture.all.order(id: :desc).page(params[:page]).per(10)
    else
      @pictures = Picture.where(user_id: current_user.id).order(id: :desc).page(params[:page]).per(10)
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
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
    @picture = Picture.new(picture_params)
    hotpepper = Nokogiri::HTML.parse(url_set(@picture.url), nil, 'utf-8')
    hotpepper.css('#contents').each do |doc|
      article_link('#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.detailTitle > a',
                    '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.fs10.fgGray',
                    '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > div > ul > li:nth-child(1)',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT5.fs14.b > a',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT10.wbba',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(2) > dd',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(3) > dd',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(4) > dd',
                    '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fl > div.pr > img',
                    doc)
    end
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
      @picture = Picture.new(url: url, user_id: current_user.id)
      hotpepper = Nokogiri::HTML.parse(url_set(@picture.url), nil, 'utf-8')
      hotpepper.css('#contents').each do |doc|
        article_link('#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.detailTitle > a',
                      '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.fs10.fgGray',
                      '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > div > ul > li:nth-child(1)',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT5.fs14.b > a',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT10.wbba',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(2) > dd',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(3) > dd',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(4) > dd',
                      '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fl > div.pr > img',
                      doc)
      end
      if @picture.save
        @success += 1 
      else
        @fail += 1
      end
    end
  end

  def collect_new
  end

  def collect_call  
    @success = 0 #登録の成功した数をカウントする変数
    @fail = 0 #登録の失敗した数をカウントする変数
    hotpepper_parent = Nokogiri::HTML.parse(url_set(params[:url]), nil, 'utf-8')
    hotpepper_parent.css('#contents').each do |hotpepper|
      hotpepper.css('div.pr.oh.jscHoverTarget > p > a').each do |doc|
        hotpepper_child = Nokogiri::HTML.parse(url_set(doc[:href]), nil, 'utf-8')
        hotpepper_child.css('#contents').each do |child_doc|
          @picture = Picture.new(url: doc[:href], user_id: current_user.id)
          article_link('#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.detailTitle > a',
                        '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > p.fs10.fgGray',
                        '#mainContents > div.detailHeader.cFix.pr > div > div.pL10.oh.hMin120 > div > div > ul > li:nth-child(1)',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT5.fs14.b > a',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(2) > div.cFix.mT10 > div.oh.pR10 > p.mT10.wbba',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(2) > dd',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(3) > dd',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fr.styleDtlRightColumn > div:nth-child(4) > dl:nth-child(4) > dd',
                        '#jsiHoverAlphaLayerScope > div.cFix.mT20.pH10 > div.fl > div.pr > img',
                        child_doc)
          if @picture.save
            @success += 1 
          else
            @fail += 1
          end
        end
      end
    end

    render 'bulk_create'
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

  def blank_pictures
    @pictures = Picture.where(picture_present: false).order(id: :desc).page(params[:page]).per(20)
    render 'index'
  end

  def point_ranking
    pictures_array = Picture.all.order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(rating: :desc).page(params[:page]).per(10)
    render 'ranking'
  end

  def midiamu_ranking
    pictures_array = Picture.where('length = ?', 'ミディアム').order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(win: :desc).limit(100).offset(0).page(params[:page]).per(10)
    render 'ranking'
  end

  def long_ranking
    pictures_array = Picture.where('length = ? OR length = ?', 'ロング', 'セミロング').order(rating: :desc).limit(100).offset(0).pluck(:id)
    @pictures = Picture.where(id: pictures_array).order(rating: :desc).page(params[:page]).per(10)
    render 'ranking'
  end

  def my_histories
    pictures_array = UserPicture.where(user_id: current_user.id).where('win > ?', 0).order(voting_at: :desc).limit(100).offset(0).pluck(:id)
    @pictures = UserPicture.where(id: pictures_array).order(voting_at: :desc).page(params[:page]).per(10)
    render 'ranking'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:url)
    end

    def article_link(shop_name, shop_name_kana, shop_address, stylist_name, stylist_profile, length, color, image, picture_url, doc)
      @picture.shop_name = doc.css(shop_name).text
      @picture.shop_name_kana = doc.css(shop_name_kana).text
      @picture.shop_address = doc.css(shop_address).text
      @picture.stylist_name = doc.css(stylist_name).text
      @picture.stylist_profile = doc.css(stylist_profile).text
      @picture.length = doc.css(length).text
      @picture.color = doc.css(color).text
      @picture.image = doc.css(image).text
      @picture.picture_url = doc.css(picture_url)[0][:src]
    end

    def url_set(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      return html
    end
end
