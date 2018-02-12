class ConflictController < ApplicationController
  def index
    set_picture(nil)
    next_picture(nil)
    @area = nil
  end

  def area_ranking
    set_picture(params[:area])
    next_picture(params[:area])
    @area = params[:area]
    p '------------------------------------------------'
    p params[:area]
    p '------------------------------------------------'

    render 'index'
  end

  def elo
    begin
      winer = Picture.find(params[:win])
      loser = Picture.find(params[:lose])
      win = Elo::Player.new(rating: winer.rating, k_factor: 12)
      lose = Elo::Player.new(rating: loser.rating, k_factor: 12)

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
        set_picture(params[:area])
      end
    rescue
      set_picture(params[:area])
    end
    next_picture(params[:area])

    @area = params[:area]
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
    def set_picture(area)
      Picture.find( Picture.where(picture_present: true).area_search(area).pluck(:id).sample )
      @picture1 = Picture.find( Picture.pluck(:id).sample )
      begin
        @picture2 = Picture.find( Picture.where(picture_present: true).area_search(area).pluck(:id).sample )
      end while @picture1.id == @picture2.id
    end

    def next_picture(area)
      @next1 = Picture.find( Picture.where(picture_present: true).area_search(area).pluck(:id).sample )
      begin
        @next2 = Picture.find( Picture.where(picture_present: true).area_search(area).pluck(:id).sample )
      end while @next1.id == @next2.id
    end
end
