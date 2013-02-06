class CreateWebParts < ActiveRecord::Migration
  def change
    create_table :web_parts do |t|
      t.string :name
      t.string :html

      t.timestamps
    end
  end
end
