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


            # TODO: Transaction this in case we fail to send the email
            pp = PlayerPortal.new
            pp.birthday= birthday
            pp.first= first
            pp.last= last
            pp.uid= SecureRandom.uuid
            pp.year= EventGroup::TRYOUT_YEAR
            pp.md5= md5

            pp.save!

            imported += 1

            # TODO: Send email for every player we import

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
