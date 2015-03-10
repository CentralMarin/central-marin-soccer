class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :type, default: 0, null: false
      t.string :heading
      t.text :body
      t.text :tout
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
