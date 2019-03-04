class CreateCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :subject
      t.string :icon_url

      t.timestamps
    end
  end
end
