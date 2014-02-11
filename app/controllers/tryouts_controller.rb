class TryoutsController < InheritedResources::Base

  @@mutex = Mutex.new

  def index
    # Combine age and gender tryouts
    @tryouts = Tryout.by_age_and_gender
  end

  def registration
    #Get all teams
    @teams = Team.all
  end

  def registration_create
    update_spreadsheet ENV['GOOGLE_DRIVE_TRYOUTS_DOC'], params

    # TODO: split out playups so coaches know what they're trying out for

    @tryout = params['tryout']
    render action: 'confirmation'
  end

  def agegroupchart
    @season = params['season'].to_i

    @years = (@season-19..@season-7)

    render :layout => 'frame'
  end

  protected

  def update_spreadsheet(title, params)

    @@mutex.synchronize do

      session = GoogleDrive.login(ENV['GOOGLE_DRIVE_USER'], ENV['GOOGLE_DRIVE_PWD'])
      ss = session.spreadsheet_by_title(title) || session.create_spreadsheet(title)
      ws = ss.worksheets[0]
      lastrow = ws.num_rows + 1

      [Time.now,
       params['player_first'],
       params['player_last'],
       params['home_address'],
       params['home_phone'],
       params['gender'],
       params['birthdate_month'] + '/' + params['birthdate_day'] + '/' + params['birthdate_year'],
       (params['play_up'] ? 'Yes' : 'No'),
       params['tryout'],
       params['previous_team'],
       params['parent1_first'],
       params['parent1_last'],
       params['parent1_email'],
       params['parent1_cell'],
       params['parent2_first'],
       params['parent2_last'],
       params['parent2_email'],
       params['parent2_cell'],
       params['form_completed_by'],
       params['relationship_to_player'],
       params['waiver'],
       request.env['HTTP_USER_AGENT']
      ].each_with_index do |cell, index|
        ws[lastrow, index + 2] = cell     # 1 Based indexing. Skip the first column so we have a place for tryout number assignment
      end

      ws.save
    end
  end
end
