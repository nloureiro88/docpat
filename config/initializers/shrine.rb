
require "cloudinary"
require "shrine/storage/cloudinary"

Cloudinary.config(
  cloud_name: "docpat",
  api_key:    "683768384476574",
  api_secret: "h3hWpC2o_gWjjh3grBX5JLlLDF0",
)

# Cloudinary.config(
#   cloud_name: ENV['docpat'],
#   api_key:ENV['683768384476574'],
#   api_secret:ENV['h3hWpC2o_gWjjh3grBX5JLlLDF0'],
# )

Shrine.storages = {
  cache: Shrine::Storage::Cloudinary.new(prefix: "cache"), # for direct uploads
  store: Shrine::Storage::Cloudinary.new(prefix: "store"),
}
