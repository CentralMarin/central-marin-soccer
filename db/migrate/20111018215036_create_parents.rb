class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string :name
      t.string :email
      t.string :home_phone
      t.string :cell_phone

      t.timestamps
    end
  end
end
