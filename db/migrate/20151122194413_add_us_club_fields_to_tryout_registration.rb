class AddUsClubFieldsToTryoutRegistration < ActiveRecord::Migration
  def change
    add_column :tryout_registrations, :state, :string
    add_column :tryout_registrations, :zip, :string
    add_column :tryout_registrations, :email, :string
    add_column :tryout_registrations, :parent1_homePhone, :string
    add_column :tryout_registrations, :parent2_homePhone, :string
    add_column :tryout_registrations, :parent1_businessPhone, :string
    add_column :tryout_registrations, :parent2_businessPhone, :string
    add_column :tryout_registrations, :emergency_contact1_name, :string
    add_column :tryout_registrations, :emergency_contact1_phone1, :string
    add_column :tryout_registrations, :emergency_contact1_phone2, :string
    add_column :tryout_registrations, :emergency_contact2_name, :string
    add_column :tryout_registrations, :emergency_contact2_phone1, :string
    add_column :tryout_registrations, :emergency_contact2_phone2, :string
    add_column :tryout_registrations, :alergies, :string
    add_column :tryout_registrations, :medical_conditions, :string
    add_column :tryout_registrations, :physician_name, :string
    add_column :tryout_registrations, :physician_phone1, :string
    add_column :tryout_registrations, :physician_phone2, :string
    add_column :tryout_registrations, :insurance_name, :string
    add_column :tryout_registrations, :insurance_phone, :string
    add_column :tryout_registrations, :policy_holder, :string
    add_column :tryout_registrations, :policy_number, :string
    remove_column :tryout_registrations, :home_phone, :string
  end
end
