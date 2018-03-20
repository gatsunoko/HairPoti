class SearchController < ApplicationController
  def index
    
  end

  def prefecture_change
    if params[:prefecture].present?
      @municipalities = Municipality.where('prefecture_id = ?', params[:prefecture])
    end
  end
end