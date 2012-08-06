
class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :admin_users_roles, :id => false do |t|
      t.references :admin_user, :role
    end
  end
end