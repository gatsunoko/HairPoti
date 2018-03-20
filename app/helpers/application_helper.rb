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

  def gender_view(gender)
    if gender == 'male'
      return 'メンズ'
    elsif gender == 'female'
      return 'レディース'
    else
      return '性別未設定'
    end
  end

  def length_view(length)
    if length == 'veryshort'
      return 'ベリーショート'
    elsif length == 'short'
      return 'ショート'
    elsif length == 'medium'
      return 'ミディアム'
    elsif length == 'semilong'
      return 'セミロング'
    elsif length == 'long'
      return 'ロング'
    else
      return '未設定'
    end
  end

  def color_view(color)
    if color == 'brown'
      return 'ブラウン・ベージュ系'
    elsif color == 'yellow'
      return 'イエロー・オレンジ系'
    elsif color == 'red'
      return 'レッド・ピンク系'
    elsif color == 'black'
      return 'アッシュ・ブラック系'
    elsif color == 'other'
      return 'その他'
    else
      return '未設定'
    end
  end
end
