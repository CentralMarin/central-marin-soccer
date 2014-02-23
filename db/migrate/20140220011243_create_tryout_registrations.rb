class CreateTryoutRegistrations < ActiveRecord::Migration
  def change
    create_table :tryout_registrations do |t|
      t.string :first
      t.string :last
      t.string :home_address
      t.string :home_phone
      t.date :birthdate
      t.integer :age
      t.integer :gender
      t.string :previous_team
      t.string :parent1_first
      t.string :parent1_last
      t.string :parent1_cell
      t.string :parent1_email
      t.string :parent2_first
      t.string :parent2_last
      t.string :parent2_cell
      t.string :parent2_email
      t.string :completed_by
      t.string :relationship
      t.boolean :waiver

      t.timestamps
    end
  end
end
