class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :bio
      t.string :position
      t.text :description
      t.integer :category
      t.timestamps
    end
    Contact.create_translation_table! :position => :string, :description => :text, :bio => :text
  end
end
