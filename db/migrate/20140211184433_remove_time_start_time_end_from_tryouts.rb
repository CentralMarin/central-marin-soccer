class RemoveTimeStartTimeEndFromTryouts < ActiveRecord::Migration
  def change
    rename_column :tryouts, :date, :start
    change_column :tryouts, :start, :datetime
    remove_column :tryouts, :time_start
    remove_column :tryouts, :time_end
    add_column :tryouts, :duration, :integer
  end
end
