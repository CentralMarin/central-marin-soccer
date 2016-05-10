require 'securerandom'

# Generate the USClub Form PDF and save to Google Drive
def generate_pdf(pp, google_session)
  pdf_file_name = PlayerPortalsController.generate_file_name(pp, 'USClub.pdf')
  folder = PlayerPortalsController.usclub_assets_path(google_session, pp)
  local_path = PlayerPortalsController.generate_club_form(pp)

  TryoutsController.upload_local_file(google_session, local_path, folder, pdf_file_name, 'application/pdf')

  # Clean up the local file system
  File.delete(local_path)
end

def generate_pdfs(player_portals)
  pdfs = []
  Dir.mktmpdir do |dir|
    player_portals.each do |player_portal|
      filename = "#{player_portal.first} #{player_portal.last}.pdf"
      PlayerPortalsController.generate_club_form(player_portal, filename, dir)
      pdfs << "#{dir}/#{filename}"
    end

    # Concatenate the pdfs together
    pdftk = PdfForms.new(Rails.configuration.x.pdftk_path)
    output = "#{dir}/output.pdf"
    pdftk.cat(pdfs, output)

    File.open(output, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), filename: 'US Club Forms.pdf', disposition: 'downloaded', type: 'application/pdf'
    end

  end
end

ActiveAdmin.register PlayerPortal do

  before_filter only: :index do
    @per_page = 10_000 if request.format == 'application/pdf' || request.format == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  filter :first_or_parent1_first_or_parent2_first_cont, as: :string, label: 'First Name'
  filter :last_or_parent1_last_or_parent2_last_cont, as: :string, label: 'Last Name'
  filter :email_or_parent1_email_or_parent2_email_cont, as: :string, label: 'Email'
  filter :gender, as: :check_boxes, label: 'Gender', collection: ['Boys', 'Girls']
  filter :birth_year, as: :check_boxes, label: 'Year', collection: proc {Event.years}
  filter :paid_club_fees, as: :select, collection: ['Yes', 'No']
  filter :oef, as: :select, collection: ['Yes', 'No']

  permit_params :uid, :first, :last, :email, :address, :city, :state, :zip, :gender, :birthday,
                :parent1_first, :parent1_last, :parent1_email, :parent1_cell, :parent1_home, :parent1_business,
                :parent2_first, :parent2_last, :parent2_email, :parent2_cell, :parent2_home, :parent2_business,
                :ec1_name, :ec1_phone1, :ec1_phone2,
                :ec2_name, :ec2_phone1, :ec2_phone2,
                :physician_name, :physician_phone1, :physician_phone2,
                :insurance_name, :insurance_phone, :policy_holder, :policy_number,
                :alergies, :conditions,
                :volunteer_choice, :picture, :amount_paid, :status =>[]

  actions :index, :show, :update, :edit, :destroy

  action_item :resend, :only => :show do
    link_to "Resend Welcome Email", :action => "resend_welcome"
  end

  member_action :resend_welcome do
    player_portal = PlayerPortal.find(params[:id])
    PlayerPortalMailer.welcome(player_portal).deliver

    flash[:notice] = "Email successfully sent"
    redirect_to :action => :show
  end

  member_action :impersonate do
    uid = params[:id]
    session[:is_authenticated] = uid
    redirect_to player_portal_path(uid)
  end

  sidebar :Statistics, only: :index do
    stats = PlayerPortal.stats
    table_for stats[:collected] do
      column '', :type
      column 'Players', :count do |stat|
        stat[:count]
      end
      column 'Collected', :collected do |stat|
        number_to_currency stat[:collected]
      end
    end
    table_for stats[:outstanding] do
      column '', :type
      column 'Players', :count do |stat|
        stat[:count]
      end
      column 'Oustanding', :collected do |stat|
        number_to_currency stat[:collected]
      end
    end

    table_for stats[:totals] do
      column '', :type
      column 'Players', :count do |stat|
        stat[:count]
      end
      column 'Potential', :collected do |stat|
        number_to_currency stat[:collected]
      end
    end
  end

  index :download_links => [:pdf, :xlsx] do

    stats = PlayerPortal.stats

    json_data = [{label: 'one', data: 500}, {label: 'two', data: 10}]

    column :portal do |portal|
      link_to 'Launch', impersonate_admin_player_portal_path(portal.uid), target: '_blank'
    end
    column :first
    column :last
    column :birthday
    column 'Club Form', :usclub_complete do |portal|
      portal.status?(:form) ? status_tag( 'yes', :ok) : status_tag('no')
    end
    column 'Birth Proof', :have_birth_certificate do |portal|
      portal.status?(:proof_of_birth) ? status_tag( 'yes', :ok) : status_tag('no')
    end
    column :picture do |portal|
      portal.status?(:picture) ? status_tag( 'yes', :ok) : status_tag('no')
    end
    column :docs_reviewed do |portal|
      portal.status?(:docs_reviewed) ? status_tag( 'yes', :ok) : status_tag('no')
    end
    column :volunteer, sortable: 'volunteer_choice' do |portal|
      portal.volunteer_choice.titleize if portal.volunteer_choice.present?
    end
    column :oef do |portal|
      portal.status?(:oef) ? status_tag( 'yes', :ok) : status_tag('no')
    end
    column :club_registration_fee do |portal|
      number_to_currency(portal.club_registration_fee)
    end
    column :amount_paid
    column :amount_due do |portal|
      number_to_currency(portal.amount_due)
    end
    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :uid
      f.input :first
      f.input :last
      f.input :email
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :gender
      f.input :birthday, start_year: Time.now.year - Event::MAX_AGE, end_year: Time.now.year - Event::MIN_AGE
      f.input :parent1_first
      f.input :parent1_last
      f.input :parent1_email
      f.input :parent1_home
      f.input :parent1_cell
      f.input :parent1_business
      f.input :parent2_first
      f.input :parent2_last
      f.input :parent2_email
      f.input :parent2_home
      f.input :parent2_cell
      f.input :parent2_business
      f.input :ec1_name, label: 'Emergency Contact Name'
      f.input :ec1_phone1, label: 'Emergency Contact Phone'
      f.input :ec1_phone2, label: 'Emergency Contact Phone'
      f.input :ec2_name, label: 'Emergency Contact Name'
      f.input :ec2_phone1, label: 'Emergency Contact Phone'
      f.input :ec2_phone2, label: 'Emergency Contact Phone'
      f.input :physician_name
      f.input :physician_phone1
      f.input :physician_phone2
      f.input :insurance_name
      f.input :insurance_phone
      f.input :policy_holder
      f.input :policy_number
      f.input :alergies
      f.input :conditions
      f.input :status, collection: PlayerPortal.values_for_status.each.map{|c| [c.to_s.gsub('_', ' '), c]}, multiple: true, as: :bitmask_attributes
      f.input :volunteer_choice, as: :select, collection: PlayerPortal::VOLUNTEER_OPTIONS.map {|key,value| [key.to_s.humanize, key]}
      f.input :picture
      f.input :amount_paid

      f.actions
    end
  end

  action_item :registration_night_link, only: :index do
    link_to "Registration Night", action: 'registration_night'
  end

  collection_action :registration_night, title: 'Generate Registration Night Spreadsheets', method: :get do

    # Sorty by Birthyear, first, and last name
    @players = PlayerPortal.all.order(:first, :last)
    @years = @players.map {|pp| pp.birthday.year}.uniq{|year| year}.sort!

    render xlsx: 'registration_night', formats: 'xlsx'
  end

  action_item :send_email_link, only: :index do
    link_to "Send Email", action: 'send_email', q: params[:q]
  end

  collection_action :send_email, title: 'Send Email' do
    @players = PlayerPortal.ransack(params[:q]).result

    render "send_email"
  end

  collection_action :process_email, title: 'Send Email', method: :post do
    i = 0
    head :ok
    #   carousel_list = params[:carousel_list]
    #
    #   # Remove existing carousel items
    #   ArticleCarousel.all.each do |carousel_item|
    #     carousel_item.destroy
    #   end
    #
    #   # Add carousel items
    #   carousel_list.each_with_index do |article_id, index|
    #     ac = ArticleCarousel.new()
    #     ac.article_id = article_id
    #     ac.carousel_order = index
    #     ac.save
    #   end
    #
    #   head :ok
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
              pp.birthday= Date.strptime(birthday, "%m/%d/%Y")
              pp.status << :proof_of_birth if row[13] == 'Central Marin Soccer Club'

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
              pp.season= Event::TRYOUT_YEAR
              pp.md5= md5

              pp.save!

              # Generate the US Club Form PDF
              generate_pdf(pp, session)

              imported += 1

              # Send email for every player we import
              PlayerPortalMailer.welcome(pp).deliver
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

  controller do
    def index
      index! do |format|
        format.pdf {
          # generate US Club forms for all selected players
          generate_pdfs(@player_portals)
        }
        format.xlsx {
          render xlsx: 'index', formats: 'xlsx'
        }
      end
    end
  end
end
