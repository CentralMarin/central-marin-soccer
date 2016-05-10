class CreateNotifications < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.string :subject
      t.text :body
      t.text :q
      t.timestamps null: false
    end
    Notification.create_translation_table! subject: :string, body: :text
  end

  def down
    drop_table :notifications
    Notification.drop_translation_table!
  end
end
