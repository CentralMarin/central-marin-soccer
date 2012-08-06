class AddEmailUniqunessIndexToCoach < ActiveRecord::Migration
  def self.up
    add_index :coaches, :email, :unique => true
  end

  def self.down
    remove_index :coaches, :email
  end
end
