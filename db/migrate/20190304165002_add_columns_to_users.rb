class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :photo, :string
    add_column :users, :address, :text
    add_column :users, :date_birth, :date
    add_column :users, :identity_card, :integer
    add_column :users, :user_type, :string
    add_column :users, :pat_blood, :string
    add_column :users, :pat_pharma, :string
    add_column :users, :pat_pharma_email, :string
    add_column :users, :doc_number, :integer
    add_column :users, :doc_institutions, :string
    add_column :users, :doc_specialties, :string
    add_column :users, :status, :string, default: 'active'
  end
end
