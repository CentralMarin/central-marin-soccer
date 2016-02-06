class CreatePlayerPortals < ActiveRecord::Migration
  def change
    create_table :player_portals do |t|
      t.string :uid
      t.date :birthday
      t.string :first
      t.string :last

      t.timestamps null: false
    end
  end
end
