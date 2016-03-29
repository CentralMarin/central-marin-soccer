class CreateNewEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.integer :category, default: 0, null: false
      t.string :title
      t.text :description
      t.string :image_url
      t.decimal :cost

      t.timestamps null: false
    end
    Event.create_translation_table! title: :string, description: :text
  end

  def down
    drop_table :events
    Event.drop_translation_table!
  end
end
