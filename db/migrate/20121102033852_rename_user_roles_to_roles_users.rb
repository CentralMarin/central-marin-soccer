class RenameUserRolesToRolesUsers < ActiveRecord::Migration
  def up
    rename_table :users_roles, :roles_users
  end

  def down
    rename_table :roles_users, :users_roles
  end
end
