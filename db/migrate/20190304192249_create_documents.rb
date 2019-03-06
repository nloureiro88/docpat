class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.string :doc_type
      t.string :exam_type
      t.string :doc_title
      t.string :tags, array: true, default: []
      t.string :url
      t.string :file_type
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
