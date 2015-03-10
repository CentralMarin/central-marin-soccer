class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.integer :type, default: 0, null: false
      t.string :heading
      t.text :body
      t.text :tout
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    Event.create_translation_table! heading: :string, body: :text, tout: :text
  end

  def down
    drop_table :events
    Event.drop_translation_table!
  end
end
