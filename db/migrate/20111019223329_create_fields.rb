class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :club
      t.string :rain_line
      t.string :map_url

      t.timestamps
    end
  end
end
