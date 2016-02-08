class CreatePlayerPortals < ActiveRecord::Migration
  def change
    create_table :player_portals do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :gender
      t.date :birthday

      t.string :parent1_first
      t.string :parent1_last
      t.string :parent1_email
      t.string :parent1_home
      t.string :parent1_cell
      t.string :parent1_business
      t.string :parent2_first
      t.string :parent2_last
      t.string :parent2_email
      t.string :parent2_home
      t.string :parent2_cell
      t.string :parent2_business

      t.string :ec1_name
      t.string :ec1_phone1
      t.string :ec1_phone2
      t.string :ec2_name
      t.string :ec2_phone1
      t.string :ec2_phone2

      t.string :physician_name
      t.string :physician_phone1
      t.string :physician_phone2

      t.string :insurance_name
      t.string :insurance_phone
      t.string :policy_holder
      t.string :policy_number

      t.string :alergies
      t.string :conditions

      t.string :uid
      t.string :md5
      t.integer :season
      t.timestamps null: false
    end
  end
end

