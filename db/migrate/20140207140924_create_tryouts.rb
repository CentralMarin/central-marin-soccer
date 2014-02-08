class CreateTryouts < ActiveRecord::Migration
  def change
    create_table :tryouts do |t|
      t.integer :gender_id
      t.integer :age
      t.date :date
      t.time :time_start
      t.time :time_end
      t.integer :field_id
      t.boolean :is_makeup

      t.timestamps
    end
  end
end
