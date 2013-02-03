class RenameArticleSubcategoryIdToTeamId < ActiveRecord::Migration
  def change
    rename_column :articles, :subcategory_id, :team_id
    add_column :articles, :coach_id, :integer
  end
end
