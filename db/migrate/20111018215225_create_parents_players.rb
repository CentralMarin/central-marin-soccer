class CreateParentsPlayers < ActiveRecord::Migration
  def change
    create_table :parents_players, :id => false do |t|
      t.integer :parent_id
      t.integer :player_id
    end
  end
end
