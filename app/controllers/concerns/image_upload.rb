module ImageUpload
  require 'kconv'
  require 'rmagick'#require sudo yum install ImageMagick ImageMagick-devel -y
  require 'aws-sdk'
  AWS.config(access_key_id: ENV["ACCESS_KEY_ID"], secret_access_key: ENV["SECRET_ACCESS_KEY"], region: 'ap-northeast-1') if Rails.env == 'production'

  def picture_up(args)
    if ENV['AWS_S3'].present?
      name = 'string'

      unless file = args[:file].nil?
        now = Time.now.strftime('%Y%m%d%H%M%S').to_s
        s3 = AWS::S3.new
        bucket = s3.buckets[ENV["AWS_S3_BUCKET"]]
        file = args[:file]
        name = file.original_filename 
        ext = name[name.rindex('.') + 1, 4].downcase

        perms = ['.jpg', '.jpeg', '.gif', '.png']
        if !perms.include?(File.extname(name).downcase)
          #@up_result[name.to_s] = 'アップロードできるのは画像ファイルのみです。'
        elsif file.size > 10.megabyte
          #@up_result[name.to_s] = 'ファイルサイズは10MBまでです。'
        else
          name = name.kconv(Kconv::SJIS, Kconv::UTF8)

          original = Magick::Image.from_blob(File.read(file.tempfile)).shift

          picture_s = original.resize_to_fit(150, 150)
          file_full_path="#{args[:dir]}/s#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase
          object = bucket.objects[file_full_path]
          object.write(picture_s.to_blob ,:acl => :public_read)

          picture_m = original.resize_to_fit(300, 300)
          file_full_path="#{args[:dir]}/m#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase
          object = bucket.objects[file_full_path]
          object.write(picture_m.to_blob ,:acl => :public_read)

          if args[:name] != 'profile'
            picture_l = original.resize_to_fit(800, 800)
            file_full_path="#{args[:dir]}/l#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase
            object = bucket.objects[file_full_path]
            object.write(picture_l.to_blob ,:acl => :public_read)
          end

          return "#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase
        end
      end
    else
      name = 'string'
      unless args[:file].nil?
        now = Time.now.strftime('%Y%m%d%H%M%S').to_s
        file = args[:file]
        name = file.original_filename 
        ext = name[name.rindex('.') + 1, 4].downcase
        perms = ['.jpg', '.jpeg', '.gif', '.png']
        if !perms.include?(File.extname(name).downcase)
          @up_result[name.to_s] = 'アップロードできるのは画像ファイルのみです。'
        elsif file.size > 10.megabyte
          @up_result[name.to_s] = 'ファイルサイズは10MBまでです。'
        else
          name = name.kconv(Kconv::SJIS, Kconv::UTF8)

          original = Magick::Image.from_blob(File.read(file.tempfile)).shift

          picture_s = original.resize_to_fit(150, 150)
          picture_s.write("public/docs/s#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase)

          picture_m = original.resize_to_fit(300, 300)
          picture_m.write("public/docs/m#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase)

          if args[:name] != 'profile'
            picture_l = original.resize_to_fit(800, 800)
            picture_l.write("public/docs/l#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase)
          end

          return "#{now}_#{current_user.id}_#{args[:picture_id]}_#{args[:name]}"+File.extname(name).downcase
        end
      end

      return nil   
    end
  end

  def picture_destroy(args)
    size = ["s", "m", "l"]
    if ENV['AWS_S3'].present?
      s3d = AWS::S3.new
      size.each do |s|
        s3d.buckets[ENV["AWS_S3_BUCKET"]].objects[args[:dir]+'/'+s+args[:picture]].delete if args[:picture].present? && s3d.buckets[ENV["AWS_S3_BUCKET"]].objects[args[:dir]+'/'+s+args[:picture]].exists?
      end
    else
      size.each do |s|
        File.delete("public/docs/"+s+args[:picture]) if args[:picture].present? && File.exist?("public/docs/"+s+args[:picture])
      end
    end
  end
end