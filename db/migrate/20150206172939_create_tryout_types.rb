class CreateTryoutTypes < ActiveRecord::Migration
  def change
    create_table :tryout_types do |t|
      t.string :name
      t.string :header
      t.text :body

      t.timestamps
    end
  end
end
