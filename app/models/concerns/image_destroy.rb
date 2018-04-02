module ImageDestroy
  extend ActiveSupport::Concern

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