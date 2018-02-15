class ConflictController < ApplicationController

  before_action :picture_count, only: [:index]

  include AjaxHelper 

  def index
    session[:area_default] = params[:area]
    session[:length_default] = params[:length]

    set_picture(params[:area], params[:length])
    next_picture(params[:area], params[:length])
    @area = params[:area]
    @length = params[:length]
    @count = 0
    session[:voting_id] = Array.new
  end

  def elo
    begin
      winer = Picture.find(params[:win])
      loser = Picture.find(params[:lose])
      win = Elo::Player.new(rating: winer.rating, k_factor: 12)
      lose = Elo::Player.new(rating: loser.rating, k_factor: 12)

      session[:voting_id].push(winer.id)

      win.wins_from(lose)
      lose.loses_from(win)

      winer.rating = win.rating
      loser.rating = lose.rating
      winer.win += 1
      loser.lose += 1
      winer.save
      loser.save

      #ユーザーがログインしていたら、そのユーザーだけのランキングを作る
      if user_signed_in?
        if UserPicture.where('user_id = ? AND picture_id = ?', current_user.id, params[:win]).exists?
          user_win = UserPicture.where('user_id = ? AND picture_id = ?', current_user.id, params[:win]).first
        else
          user_win = UserPicture.new(user_id: current_user.id, picture_id: params[:win])
        end
        if UserPicture.where('user_id = ? AND picture_id = ?', current_user.id, params[:lose]).exists?
          user_lose = UserPicture.where('user_id = ? AND picture_id = ?', current_user.id, params[:lose]).first
        else
          user_lose = UserPicture.new(user_id: current_user.id, picture_id: params[:lose])
        end

        win = Elo::Player.new(rating: user_win.rating, k_factor: 12)
        lose = Elo::Player.new(rating: user_lose.rating, k_factor: 12)

        win.wins_from(lose)
        lose.loses_from(win)
        user_win.rating = win.rating
        user_lose.rating = lose.rating
        user_win.win += 1
        user_lose.lose += 1
        user_win.voting_at = Time.now
        user_win.save
        user_lose.save
      end

      @picture1 = Picture.find params[:next1]
      @picture2 = Picture.find params[:next2]

      while @picture1.picture_present == false || @picture2.picture_present == false
        set_picture(params[:area], params[:length])
      end
    rescue
      set_picture(params[:area], params[:length])
    end
    next_picture(params[:area], params[:length])

    @area = params[:area]
    @length = params[:length]
    @count = params[:count].to_i + 1

    if @count >= 10
      respond_to do |format|
        format.js { render ajax_redirect_to(conflict_result_path) }
      end
    end
  end

  def result
    @pictures = Picture.where(id: session[:voting_id]).order(['field(id, ?)', session[:voting_id].reverse])
  end

  def img_blank
    begin
      picture = Picture.find(params[:picture_id])
      picture.picture_present = false
      picture.save
    rescue

    end

    redirect_back(fallback_location: root_path)
  end

  private
    #該当する写真が5枚以下なら投票画面に行かない
    def picture_count
      if Picture.where(picture_present: true).area_search(params[:area]).length_search(params[:length]).count <= 10
        redirect_back(fallback_location: root_path) and return
      end
    end

    def set_picture(area, length)
      @picture1 = Picture.find( Picture.where(picture_present: true).area_search(area).length_search(length).pluck(:id).sample)
      begin
        second_length = @picture1.length
        @picture2 = Picture.find(Picture.where(picture_present: true).area_search(area).length_search(second_length).pluck(:id).sample)
      end while @picture1.id == @picture2.id
    end

    def next_picture(area, length)
      @next1 = Picture.find(Picture.where(picture_present: true).area_search(area).length_search(length).pluck(:id).sample)
      begin
        second_length = @next1.length
        @next2 = Picture.find(Picture.where(picture_present: true).area_search(area).length_search(second_length).pluck(:id).sample)
      end while @next1.id == @next2.id
    end
end
