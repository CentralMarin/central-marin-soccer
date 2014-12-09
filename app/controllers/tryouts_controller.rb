class TryoutsController < InheritedResources::Base

  @@mutex = Mutex.new

  def index
    # Combine age and gender tryouts
    @tryouts = Tryout.by_age_and_gender
  end

  def registration
    @tryout_registration = TryoutRegistration.new
  end

  def registration_create

    @tryout_registration = TryoutRegistration.new(params.required(:tryout_registration)
                                                  .permit(:first, :last, :home_address, :home_phone, :city, :gender, :birthdate,
                                                          :age, :previous_team, :parent1_first, :parent1_last,
                                                          :parent1_cell, :parent1_email, :parent2_first, :parent2_last,
                                                          :parent2_cell, :parent2_email, :completed_by, :relationship, :waiver))

    if not @tryout_registration.birthdate.nil?
      @tryout_registration.age = Tryout.calculate_age_level(@tryout_registration.birthdate.month, @tryout_registration.birthdate.year)
    end

    if @tryout_registration.save

      # Save to google spreadsheet - Age Specific Tab
      update_spreadsheet Rails.application.secrets.google_drive_tryouts_doc, @tryout_registration

      # Tryout info
      @tryout_info = lookup_tryout(@tryout_registration.birthdate.month, @tryout_registration.birthdate.year, Gender.new(@tryout_registration.gender))

      # Send confirmation email
#      TryoutMailer.signup_confirmation(@tryout_registration, @tryout_info).deliver

      render :action => 'confirmation'
    else
      render :registration
    end

  end

  def agegroupchart
    @season = params['season'].to_i

    @years = (@season-19..@season-7)

    render :layout => 'frame'
  end

  def agelevel
    # Determine the age level based on birthdate and gender
    year = params['year'].to_i
    month = params['month'].to_i
    gender = Gender.new(params['gender'].to_i)

    @tryout_info = lookup_tryout(month, year, gender)

    render :layout => 'frame'
  end

  protected

  def lookup_tryout(month, year, gender)
    # find the tryout
    Tryout.tryouts_for_age_and_gender(Tryout.calculate_age_level(month, year), gender)
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
       'Home Address',
       'City',
       'Home Phone',
       'Gender',
       'Birthdate',
       'Play up',
       'Level',
       'Previous Team',
       'Parent1 First',
       'Parent1 Last',
       'Parent1 Email',
       'Parent1 Cell',
       'Parent2 First',
       'Parent2 Last',
       'Parent2 Email',
       'Parent2 Cell',
       'Signor',
       'Relationship',
       'Agreement'].each_with_index do |cell, index|

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

        session = GoogleDrive.login(Rails.application.secrets.google_drive_user, Rails.application.secrets.google_drive_pwd)
        ss = session.spreadsheet_by_title(title)
        if ss.nil?
          ss = session.create_spreadsheet(title)
        end
        ws = get_worksheet(ss, Tryout.tryout_name(registration_info.age, Gender.new(registration_info.gender)))
        last_row = ws.num_rows + 1

        gender = Gender.new(registration_info.gender).to_s
        # Be explicit about order
        ['',
         Time.now,
         registration_info.first,
         registration_info.last,
         registration_info.home_address,
         registration_info.city,
         registration_info.home_phone,
         gender,
         registration_info.birthdate,
         'No',
         registration_info.age.to_s + gender[0],
         registration_info.previous_team,
         registration_info.parent1_first,
         registration_info.parent1_last,
         registration_info.parent1_email,
         registration_info.parent1_cell,
         registration_info.parent2_first,
         registration_info.parent2_last,
         registration_info.parent2_email,
         registration_info.parent2_cell,
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
