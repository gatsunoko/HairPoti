module PrefectureEnding
  extend ActiveSupport::Concern

  def prefecture_ending(prefecture)
    area = Area.find(prefecture).name
    if area == '東京'
      return area+'都'
    elsif area == '大阪' || area == '京都'
      return area+'府'
    elsif area == '北海道'
      return area
    else
      return area+'県'
    end
  end
end