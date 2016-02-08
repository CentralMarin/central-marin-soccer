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

    # format phone numbers
    [
        :parent1_home, :parent1_cell, :parent1_business, :parent2_home, :parent2_cell, :parent2_business,
        :ec1_phone1, :ec1_phone2, :ec2_phone1, :ec2_phone2,
        :physician_phone1, :physician_phone2,
        :insurance_phone
    ].each {|sym| hash[sym.to_s] = format_phone(hash[sym.to_s])}

    hash
  end

  protected

  def format_phone(phone)
    if phone.blank?
      ""
    else
      "(#{phone[0..2]}) #{phone[3..5]} - #{phone[6..9]}"
    end

  end

end