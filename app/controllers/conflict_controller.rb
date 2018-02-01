class ConflictController < ApplicationController
  def index
    @card1 = Picture.where( 'id >= ?', rand(Picture.first.id..Picture.last.id) ).first
    begin
      @card2 = Picture.where( 'id >= ?', rand(Picture.first.id..Picture.last.id) ).first
    end while @card1.id == @card2.id
  end

  def elo
    redirect_to conflict_index_path
  end
end
