class DocumentUploader < CarrierWave::Uploader::Base
    include Cloudinary::CarrierWave
    #include Cloudinary::Utils.private_download_url

  def extension_whitelist
     %w(jpg jpeg gif png pdf doc docx)
  end

  def store_dir
    #"docpatpro/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "docpatpro/"
  end

end
