class TryoutRegistrationYear < ActiveRecord::Migration
  def change
    add_column :tryout_registrations, :year, :integer

    TryoutRegistration.find_each do |registration|
      registration_date = registration.updated_at

      season_2014_begin = Time.new(2013, 10, 2)
      season_2014_end = Time.new(2014,10,1)
      season_2015_begin = Time.new(2014, 10, 2)
      season_2015_end = Time.new(2015,10,1)
      season_2016_begin = Time.new(2015, 10, 2)
      season_2016_end = Time.new(2016,10,1)

      if registration_date >= season_2014_begin && registration_date <= season_2014_end
        puts "#{registration.updated_at.to_s}: season 2014"
        registration.year = 2014
      elsif registration_date >= season_2015_begin && registration_date <= season_2015_end
        puts "#{registration.updated_at.to_s}: season 2015"
        registration.year = 2015
      elsif registration_date >= season_2016_begin && registration_date <= season_2016_end
        puts "#{registration.updated_at.to_s}: season 2016"
        registration.year = 2016
      else
        puts "#{registration.updated_at.to_s}: Unknown season"
      end
      #registration.save!
    end
  end
end
