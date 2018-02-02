class ConflictController < ApplicationController
  def index
    @picture1 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
    begin
      @picture2 = Picture.where('id >= ?', rand(Picture.first.id..Picture.last.id)).first
    end while @picture1.id == @picture2.id
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
      user_win.save
      user_lose.save
    end

    redirect_to conflict_index_path
  end
end
