class PlayerPortal < ActiveRecord::Base

  after_initialize :init

  attr_accessor :club_registration_fee,
                :team_year,
                :birth_year

  # Credit Card Processing Fees
  CC_PERCENTAGE = 0.022
  CC_FIXED = 0.3
  VOLUNTEER_OPT_OUT_FEE = 100

  # Volunteer Options - i18n string lookup
  VOLUNTEER_OPTIONS = {
      opt_out: 'volunteer.options.opt_out',
      fields: 'volunteer.options.fields',
      manager: 'volunteer.options.manager',
      travel: 'volunteer.options.travel',
      board: 'volunteer.options.board',
      tournament: 'volunteer.options.tournament',
      tryout: 'volunteer.options.tryout',
      no_preference: 'volunteer.options.no_preference'
  }

  def init
    unless birthday.nil?
      self.birth_year= birthday.year
      self.team_year= "U#{Time.now.year - birth_year + 1}"
      self.club_registration_fee=  TEAM_COSTS[team_year.to_sym]
    end
  end

  def to_hash
    hash = serializable_hash

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

  TEAM_COSTS = {
      U8: 1050,
      U9: 500,
      U10: 500,
      U11: 550,
      U12: 550,
      U13: 550,
      U14: 550,
      U15: 550,
      U16: 550,
      U17: 550,
      U18: 550,
      U19: 550,
  }

  def format_phone(phone)
    if phone.blank?
      ""
    else
      "(#{phone[0..2]}) #{phone[3..5]} - #{phone[6..9]}"
    end

  end

end