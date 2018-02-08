class ConflictController < ApplicationController
  def index
    set_picture
    next_picture
  end

  def elo
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
    next_picture
  end

  def img_blank
    picture = Picture.find(params[:picture_id])
    picture.destroy
    redirect_back(fallback_location: root_path)
  end

  private
    def set_picture
      @picture1 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
      begin
        @picture2 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
      end while @picture1.id == @picture2.id
    end

    def next_picture
      @next1 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
      begin
        @next2 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
      end while @next1.id == @next2.id
    end
end
