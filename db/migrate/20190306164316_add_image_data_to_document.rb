class AddImageDataToDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :file, :string
  end
end
