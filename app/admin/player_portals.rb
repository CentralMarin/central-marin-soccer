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

    # TODO: Send email for every player we import

    imported = 0

    # Iterate over all rows in each checking for columns that have selected = Y
    ss.worksheets.each do |sheet|
      sheet.rows.each do |row|
        selected = row[45]
        if selected == 'Y' || selected == 'y'
          pp = PlayerPortal.new
          pp.birthday= row[10]
          pp.first= row[2]
          pp.last= row[3]
          pp.uid= SecureRandom.uuid
          pp.save!

          imported += 1
        end
      end
    end

    flash[:notice] = "Imported #{imported} players"
    redirect_to :action => :index
  end
end
