class RenameAdminUserRolesToUserRoles < ActiveRecord::Migration
  def up
    rename_table :admin_users_roles, :users_roles
  end

  def down
    rename_table :users_roles, :admin_users_roles
  end
end
