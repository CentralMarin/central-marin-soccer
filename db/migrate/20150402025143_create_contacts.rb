class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :bio
      t.string :club_position
      t.text :description
      t.integer :category
      t.integer :row_order
      t.timestamps
    end
    Contact.create_translation_table! :club_position => :string, :description => :text, :bio => :text
  end
end
