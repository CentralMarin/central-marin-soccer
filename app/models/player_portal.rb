class PlayerPortal < ActiveRecord::Base

  def to_hash
    hash = serializable_hash()

    # Add our default
    hash[:name] = "#{first} #{last}"
    hash[:birthday] = birthday.strftime('%m/%d/%Y')
    hash[:female] =  (gender == 'Girls' ? 'Yes' : 'No')
    hash[:male] =  (gender == 'Boys' ? 'Yes' : 'No')

    hash[:club_name] = "Central Marin Soccer Club"
    hash[:club_city] = "San Rafael"
    hash[:club_state] = "CA"
    hash[:league_name] = "Norcal Premier Soccer"

    hash[:parent1_name] = "#{parent1_first} #{parent1_last}"
    hash[:parent2_name] = "#{parent2_first} #{parent2_last}"

    hash
  end

end