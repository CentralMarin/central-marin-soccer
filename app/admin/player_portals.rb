require 'securerandom'

ActiveAdmin.register PlayerPortal do

  permit_params :uid, :first, :last, :birthday

  index :download_links => false do
    column :uid do |portal|
      link_to portal.uid, player_portal_path(portal.uid)
    end
    column :first
    column :last
    column :birthday
    column :created_at
    column :updated_at

    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :uid
      f.input :first
      f.input :last
      f.input :birthday, start_year: Time.now.year - EventGroup::MAX_AGE, end_year: Time.now.year - EventGroup::MIN_AGE

      f.actions
    end
  end

  action_item :import, :only => :index do
    link_to "Import Players", :action => "player_portal_import"
  end

  collection_action :player_portal_import, :title => "Import", :method => :get do

    # Hookup to the Google Drive
    session = TryoutsController.authorize
    ss = session.spreadsheet_by_title TryoutRegistration.sheet_name

    # Handle missing spreadsheet
    if ss.nil?
      flash[:notice] = "Unable to find Google Sheet #{TryoutRegistration.sheet_name}"
      redirect_to :action => :index
      return
    end

    imported = 0
    skipped = 0

    # Iterate over all rows in each checking for columns that have selected = Y
    ss.worksheets.each do |sheet|
      sheet.rows.each do |row|
        selected = row[45]
        if selected == 'Y' || selected == 'y'

          first = row[2]
          last = row[3]
          birthday = row[10]
          md5 = Digest::MD5.hexdigest("#{first}|#{last}|#{birthday}")

          # Check if we already have this record
          pp = PlayerPortal.find_by_md5(md5)
          if pp.nil?

            PlayerPortal.transaction do
              # TODO: Transaction this in case we fail to send the email
              # TODO: Move away from Google Sheets for next season
              pp = PlayerPortal.new
              pp.first= first
              pp.last= last
              pp.email= row[4]
              pp.address= row[5]
              pp.city= row[6]
              pp.state= row[7]
              pp.zip= row[8]
              pp.gender= row[9]
              pp.birthday= birthday

              pp.parent1_first= row[14]
              pp.parent1_last= row[15]
              pp.parent1_email= row[16]
              pp.parent1_home= row[17]
              pp.parent1_business= row[18]
              pp.parent1_cell= row[19]

              pp.parent2_first= row[20]
              pp.parent2_last= row[21]
              pp.parent2_email= row[22]
              pp.parent2_home= row[23]
              pp.parent2_business= row[24]
              pp.parent2_cell= row[25]

              pp.ec1_name= row[26]
              pp.ec1_phone1= row[27]
              pp.ec1_phone2= row[28]
              pp.ec2_name= row[29]
              pp.ec2_phone1= row[30]
              pp.ec2_phone2= row[31]

              pp.physician_name= row[32]
              pp.physician_phone1= row[33]
              pp.physician_phone2= row[34]

              pp.insurance_name= row[35]
              pp.insurance_phone= row[36]
              pp.policy_holder= row[37]
              pp.policy_number = row[38]

              pp.alergies= row[39]
              pp.conditions= row[40]

              pp.uid= SecureRandom.uuid
              pp.season= EventGroup::TRYOUT_YEAR
              pp.md5= md5

              pp.save!

              imported += 1

              # TODO: Send email for every player we import

            end
          else
            skipped += 1
          end

        end
      end
    end

    flash[:notice] = "Imported #{imported} players. Skipped #{skipped} already imported players."
    redirect_to :action => :index
  end
end