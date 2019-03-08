class DocumentUploader < Shrine
  # plugins and uploading logic
  Shrine::Storage::Cloudinary.new(resource_type: "raw") # "image", "video" or "raw"
  Shrine::Storage::Cloudinary.new(prefix: "docpatpro")
  Shrine::Storage::Cloudinary.new(upload_options: {backup: false})
  Shrine::Storage::Cloudinary.new(store_data: true)
  Shrine::Storage::Cloudinary.new(
  large: 10*1024*1024, upload_options: {chunk_size: 5*1024*1204})

  plugin :validation_helpers
  plugin :determine_mime_type
  plugin :parallelize
  plugin :logging, logger: Rails.logger
  plugin :remove_attachment
  plugin :delete_raw

  plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :add_metadata
  plugin :default_url
  plugin :restore_cached_data
  plugin :cached_attachment_data

  Attacher.validate do
      validate_max_size 1*1024*1024, message: "is too large (max is 10 MB)"
      validate_extension_inclusion [/jpe?g/, "png", "gif", "txt", "pdf", "doc", "docx", "xls", "xlsx"]
      validate_mime_type_inclusion ["image/jpeg", "image/png", "image/gif", "application/pdf", "text/plain",
                                    "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                    "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]
    #end
  end

default_folder= "https://cloudinary.com/console/media_library/folders/all/docpatpro"

  Attacher.default_url do |options|
    "https://s3.eu-west-2.amazonaws.com/pearlapp/app_assets/document-placeholder.png"
  end

end
