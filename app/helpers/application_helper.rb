module ApplicationHelper
  def display_picture(params)
    if ENV['AWS_S3'].present?
      if params[:name].present?
        return ENV['AWS_PICTURE_PATH']+ENV[params[:dir]]+"/"+params[:size]+params[:name]
      else
        return ''
      end
    else
      return "/docs/#{params[:size]}#{params[:name]}"
    end
  end

  def picture_genre(genre)
    if genre == 'picture_front'
      return 'フロント'
    elsif genre == 'picture_side'
      return 'サイド'
    elsif genre == 'picture_back'
      return 'バック'
    elsif genre == 'overroll'
      return '全体'
    else
      return 'その他'
    end
      
  end
end
