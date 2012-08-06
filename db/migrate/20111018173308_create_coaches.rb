class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :email
      t.text :bio

      t.timestamps
    end
  end
end
