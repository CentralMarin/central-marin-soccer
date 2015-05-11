class DropTryouts < ActiveRecord::Migration
  def change
    drop_table :tryouts
    drop_table :tryout_types
    drop_table :tryout_type_translations
  end
end
