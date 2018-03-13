module ApplicationHelper
  def display_picture(params)
    if ENV['AWS_S3'].present?
      if params[:name].present?
        return ENV['AWS_PICTURE_PATH']+ENV[params[:backet]]+"/"+params[:size]+params[:name]
      else
        return ''
      end
    else
      return "/docs/#{params[:size]}#{params[:name]}"
    end
  end
end
