class RemoveLimits < ActiveRecord::Migration
  def change
    change_column :teams, :gender_id, :integer, :limit => nil
    change_column :web_part_translations, :html, :text, :limit => nil
    change_column :web_parts, :html, :text, :limit => nil
  end
end
