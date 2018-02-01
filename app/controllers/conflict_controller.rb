class ConflictController < ApplicationController
  def index
    @picture1 = Picture.where( 'id >= ?', rand(Picture.first.id..Picture.last.id) ).first
    begin
      @picture2 = Picture.where( 'id >= ?', rand(Picture.first.id..Picture.last.id) ).first
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

    redirect_to conflict_index_path
  end
end
