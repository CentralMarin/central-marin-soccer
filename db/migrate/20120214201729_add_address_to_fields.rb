class AddAddressToFields < ActiveRecord::Migration
  def change
    add_column :fields, :address, :string
  end
end
