class TryoutsController < CmsController

  @@mutex = Mutex.new

  def index
    init_web_parts('Tryouts Overview')

    @year = EventGroup::TRYOUT_YEAR
    @info, age_group  = Event.tryout_related_events
  end

  def registration
    @tryout_registration = TryoutRegistration.new
  end

  def registration_create

    @tryout_registration = TryoutRegistration.new(params.required(:tryout_registration)
                                                  .permit(:first, :last, :email, :home_address, :city, :zip, :gender, :birthdate,
                                                          :age, :previous_team, :parent1_first, :parent1_last, :parent1_homePhone, :parent1_businessPhone,
                                                          :parent1_cell, :parent1_email, :parent2_first, :parent2_last, :parent2_homePhone, :parent2_businessPhone,
                                                          :parent2_cell, :parent2_email, :emergency_contact1_name, :emergency_contact1_phone1, :emergency_contact1_phone2,
                                                          :emergency_contact2_name, :emergency_contact2_phone1, :emergency_contact2_phone2,
                                                          :physician_name, :physician_phone1, :physician_phone2, :insurance_name, :insurance_phone,
                                                          :policy_holder, :policy_number, :alergies, :medical_conditions,
                                                          :completed_by, :relationship, :waiver))

    @tryout_registration.age = EventGroup.age_group(@tryout_registration.birthdate.year) unless @tryout_registration.birthdate.nil?

    if @tryout_registration.save

      # Make phone numbers consistent
      @tryout_registration.parent1_homePhone = format_phone_number(@tryout_registration.parent1_homePhone)
      @tryout_registration.parent1_businessPhone = format_phone_number(@tryout_registration.parent1_businessPhone)
      @tryout_registration.parent1_cell = format_phone_number(@tryout_registration.parent1_cell)
      @tryout_registration.parent2_homePhone = format_phone_number(@tryout_registration.parent2_homePhone)
      @tryout_registration.parent2_businessPhone = format_phone_number(@tryout_registration.parent2_businessPhone)
      @tryout_registration.parent2_cell = format_phone_number(@tryout_registration.parent2_cell)
      @tryout_registration.emergency_contact1_phone1 = format_phone_number(@tryout_registration.emergency_contact1_phone1)
      @tryout_registration.emergency_contact1_phone2 = format_phone_number(@tryout_registration.emergency_contact1_phone2)
      @tryout_registration.emergency_contact2_phone1 = format_phone_number(@tryout_registration.emergency_contact2_phone1)
      @tryout_registration.emergency_contact2_phone2 = format_phone_number(@tryout_registration.emergency_contact2_phone2)
      @tryout_registration.physician_phone1 = format_phone_number(@tryout_registration.physician_phone1)
      @tryout_registration.physician_phone2 = format_phone_number(@tryout_registration.physician_phone2)
      @tryout_registration.insurance_phone = format_phone_number(@tryout_registration.insurance_phone)

      # Save to google spreadsheet - Age Specific Tab
      update_spreadsheet "#{EventGroup::TRYOUT_YEAR} #{Rails.application.secrets.google_drive_tryouts_doc}", @tryout_registration

      # Tryout info
      @tryout, @age_group = lookup_tryout(Gender.new(@tryout_registration.gender), @tryout_registration.birthdate.year)

      # Send confirmation email
      TryoutMailer.signup_confirmation(@tryout_registration, @tryout).deliver

      render :action => 'confirmation'
    else
      render :registration
    end

  end

  def agegroupchart

    age_group_info = {
        'U8' => ['4x4', '3 x 15', '4', '0'],
        'U9' => ['7x7', '2 x 25', '4', '1'],
        'U10' => ['7x7', '2 x 25', '4', '1'],
        'U11' => ['9x9', '2 x 30', '4', '1'],
        'U12' => ['9x9', '2 x 30', '4', '1'],
        'U13' => ['11x11', '2 x 35', '5', '3'],
        'U14' => ['11x11', '2 x 40', '5', '3'],
        'U15' => ['11x11', '2 x 40', '5', '3'],
        'U16' => ['11x11', '2 x 40', '5', '3'],
        'U17' => ['11x11', '2 x 45', '5', '3'],
        'U19' => ['11x11', '2 x 45', '5', '3'],
    }

    @season = EventGroup::TRYOUT_YEAR
    @chart_info = []

    # Calculate matrix information
    (EventGroup::MIN_AGE..EventGroup::MAX_AGE - 1).each do |age|
      chart_row = []
      chart_row[0] = @season - age
      chart_row[1] = "U#{EventGroup.age_group(chart_row[0])}"

      @chart_info.append chart_row + age_group_info[chart_row[1]]
    end

    render :layout => 'frame'
  end

  def agelevel
    # Determine the age level based on birthdate and gender
    year = params['year'].to_i
    gender = Gender.new(params['gender'].to_i)

    @tryout, @age_group = lookup_tryout(gender, year)

    # Minify the HTML so we can make it part of the JSON
    html = render_to_string :partial => 'tryout_info.html', :locals => {tryout: @tryout}
    minified = HtmlPress.press html

    respond_to do |format|
      format.json { render json: { html: minified, status: @tryout != nil }}
    end
  end

  protected

  def lookup_tryout(gender, year)
    events, age_group = Event.tryouts(gender, year)

    return (events.empty? ? nil : events[0]), age_group
  end

  def format_phone_number(phone_number)

    if phone_number.blank?
      return phone_number
    end

    # Get the digits
    phone_number.gsub(/[^\d]/, '')
  end

  def get_worksheet(ss, sheet_name)

    age_level_sheet = ss.worksheet_by_title(sheet_name);

    if age_level_sheet.nil?
      # Create the sheet
      age_level_sheet = ss.add_worksheet(sheet_name)
      age_level_sheet.save

      # add the header rows
      ['Bib #',
       'Date Submitted',
       'First',
       'Last',
       'Email',
       'Home Address',
       'City',
       'State',
       'Zip',
       'Gender',
       'Birthdate',
       'Play up',
       'Level',
       'Previous Team',
       'Parent1 First',
       'Parent1 Last',
       'Parent1 Email',
       'Parent1 Home Phone',
       'Parent1 Business Phone',
       'Parent1 Cell',
       'Parent2 First',
       'Parent2 Last',
       'Parent2 Email',
       'Parent2 Home Phone',
       'Parent2 Business Phone',
       'Parent2 Cell',
       'Emergency Contact1',
       'Emergency Contact1 Phone1',
       'Emergency Contact1 Phone2',
       'Emergency Contact2',
       'Emergency Contact2 Phone1',
       'Emergency Contact2 Phone2',
       'Physician',
       'Physician Phone1',
       'Physician Phone2',
       'Insurance Name',
       'Insurance Phone',
       'Policy Holder',
       'Policy Number',
       'Alergies',
       'Medical Conditions',
       'Signor',
       'Relationship',
       'Agreement',
       'User Agent',
       'Selected',
       'Birth Certificate',
       'USClub Form',
       'Amount Paid & Check #'].each_with_index do |cell, index|

        age_level_sheet[1, index + 1] = cell     # 1 Based indexing
      end
      age_level_sheet.save
    end

    return age_level_sheet;
  end

  def update_spreadsheet(title, registration_info)

    @@mutex.synchronize do

      # make sure we submit everything in English
      I18n.with_locale(:en) do

        # Initialize Google Client
        api_client = Google::APIClient.new(application_name: 'Central Marin Soccer Tryouts', application_version: '1.0.0')
        drive = api_client.discovered_api('drive', 'v2')

        # Load Credentials
        key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.root.join('config', Rails.application.secrets.google_key_file).to_s, Rails.application.secrets.google_key_secret)
        asserter = Google::APIClient::JWTAsserter.new(
          Rails.application.secrets.google_service_account_id,
          'https://www.googleapis.com/auth/drive',
          key
        )

        # Authorize
        api_client.authorization = asserter.authorize(Rails.application.secrets.google_drive_account)
        session = GoogleDrive.login_with_oauth(api_client.authorization.access_token)

        ss = session.spreadsheet_by_title(title)
        if ss.nil?
          ss = session.create_spreadsheet(title)
        end

        gender = Gender.new(registration_info.gender).to_s
        ws = get_worksheet(ss, "#{gender} U#{registration_info.age}")
        last_row = ws.num_rows + 1

        # Be explicit about order
        ['',
         Time.now,
         registration_info.first,
         registration_info.last,
         registration_info.email,
         registration_info.home_address,
         registration_info.city,
         'CA',
         registration_info.zip,
         gender.to_s,
         registration_info.birthdate,
         'No',
         registration_info.age.to_s + gender[0],
         registration_info.previous_team,
         registration_info.parent1_first,
         registration_info.parent1_last,
         registration_info.parent1_email,
         registration_info.parent1_homePhone,
         registration_info.parent1_businessPhone,
         registration_info.parent1_cell,
         registration_info.parent2_first,
         registration_info.parent2_last,
         registration_info.parent2_email,
         registration_info.parent2_homePhone,
         registration_info.parent2_businessPhone,
         registration_info.parent2_cell,
         registration_info.emergency_contact1_name,
         registration_info.emergency_contact1_phone1,
         registration_info.emergency_contact1_phone2,
         registration_info.emergency_contact2_name,
         registration_info.emergency_contact2_phone1,
         registration_info.emergency_contact2_phone2,
         registration_info.physician_name,
         registration_info.physician_phone1,
         registration_info.physician_phone2,
         registration_info.insurance_name,
         registration_info.insurance_phone,
         registration_info.policy_holder,
         registration_info.policy_number,
         registration_info.alergies,
         registration_info.medical_conditions,
         registration_info.completed_by,
         registration_info.relationship,
         registration_info.waiver,
         request.env['HTTP_USER_AGENT']
        ].each_with_index do |cell, index|
          ws[last_row, index + 1] = cell     # 1 Based indexing
        end

        ws.save
      end
    end

  end
end
