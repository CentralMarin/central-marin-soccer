class TryoutsController < InheritedResources::Base

  @@mutex = Mutex.new

  def index

  end

  def registration
    #Get all teams
    @teams = Team.all
  end

  def registration_create
    update_spreadsheet '2014 Tryout Registration', params

    # TODO: split out playups so coaches know what they're trying out for

    @tryout = params['tryout']
    render action: 'confirmation'
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
       params['agree'],
       request.env['HTTP_USER_AGENT']
      ].each_with_index do |cell, index|
        ws[lastrow, index + 1] = cell
      end

      ws.save
    end
  end
end
