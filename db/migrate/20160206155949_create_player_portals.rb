class CreatePlayerPortals < ActiveRecord::Migration
  def change
    create_table :player_portals do |t|
      t.string :uid
      t.date :birthday
      t.string :first
      t.string :last
      t.string :md5
      t.integer :year
      t.timestamps null: false
    end
  end
end
