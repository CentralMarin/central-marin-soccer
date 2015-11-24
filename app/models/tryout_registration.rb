class TryoutRegistration < ActiveRecord::Base

  validates :first,  :presence => true, allow_blank: false
  validates :last, :presence => true, allow_blank: false
  validates :home_address, :presence => true, allow_blank: false
  validates :city, :presence => true, allow_blank: false
  validates :zip, :presence => true, allow_blank: false
  validates :gender, :presence => true, allow_blank: false
  validates :birthdate, :presence => true, allow_blank: false
  validates :age, :presence => true, allow_blank: false
  validates :previous_team, :presence => true, allow_blank: false
  validates :parent1_first, :presence => true, allow_blank: false
  validates :parent1_last, :presence => true, allow_blank: false
  validates :parent1_homePhone, :presence => true, allow_blank: false
  validates :parent1_email, :presence => true, allow_blank: false
  validates :emergency_contact1_name, :presence => true, allow_blank: false
  validates :emergency_contact1_phone1, :presence => true, allow_blank: false
  validates :physician_name, :presence => true, allow_blank: false
  validates :insurance_name, :presence => true, allow_blank: false
  validates :policy_holder, :presence => true, allow_blank: false
  validates :policy_number, :presence => true, allow_blank: false
  validates :alergies, :presence => true, allow_blank: false
  validates :medical_conditions, :presence => true, allow_blank: false
  validates :completed_by, :presence => true, allow_blank: false
  validates :relationship, :presence => true, allow_blank: false
  validates :waiver, :presence => true, allow_blank: false

end
