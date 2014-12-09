class AddCityToTryoutRegistration < ActiveRecord::Migration
  def change
    add_column :tryout_registrations, :city, :string
  end
end
