class RenameAdminUserIdToUserId < ActiveRecord::Migration
  def up
    rename_column :roles_users, :admin_user_id, :user_id
  end

  def down
    rename_column :roles_users, :user_id, :admin_user_id
  end
end
