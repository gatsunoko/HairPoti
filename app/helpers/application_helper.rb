module ApplicationHelper
  def display_picture(size, name)
    if ENV['AWS_S3'].present?
      return ENV['AWS_PICTURE_PATH']+ENV['ARTICLE_PICTURE_DIR']+"/"+@article.article_photos[0].original_name
    else
      return "/docs/#{size}#{name}"
    end
  end
end
