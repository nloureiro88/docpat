class AddImageDataToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :image_data, :text
  end
end
