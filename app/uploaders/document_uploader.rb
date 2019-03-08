class DocumentUploader < Shrine
  # plugins and uploading logic
  Shrine::Storage::Cloudinary.new(resource_type: "raw") # "image", "video" or "raw"
  Shrine::Storage::Cloudinary.new(prefix: "docpatpro")
  Shrine::Storage::Cloudinary.new(upload_options: {backup: false})
  Shrine::Storage::Cloudinary.new(store_data: true)

  Shrine::Storage::Cloudinary.new(
  large: 10*1024*1024, upload_options: {chunk_size: 5*1024*1204})
end
