# encoding: utf-8
# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  age           :integer
#  gender        :string(255)
#  name          :string(255)
#  coach_id      :integer
#  team_level_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class Team < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail

  belongs_to :coach
  belongs_to :team_level

  default_scope :include => [:team_level, :coach]
  scope :academy, lambda {|year| where("year >= ?", year - ACADEMY_YEAR)}
  scope :boys, lambda { where(gender_id: 0).order([:year, :team_level_id]) }
  scope :girls, lambda { where(gender_id: 1).order([:year, :team_level_id]) }

  validates :year, :presence => true
  validates :gender, :presence => true
  validates :coach, :presence => true
  validates :team_level, :presence => true
  validates :teamsnap_team_id, :presence => true

  TEAMSNAP_ROSTER_ID = '1893703'
  TEAMSNAP_NO_TEAM_ID = '0000'

  attr_accessible :coach_id, :team_level_id, :gender, :year, :name, :image, :teamsnap_team_id, :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_team_image
  mount_uploader :image, TeamImageUploader

  def gender
    Team.genders[self.gender_id] unless gender_id.nil?
  end

  def gender=(gender)
    self.gender_id = Team.genders.index(gender) || Team.genders[0]
  end

  def page_title
    self.to_s
  end

  def age
    return nil if year.nil?

    # Age is calculated from Aug 1 - July 31. Aug 1, team ages up. Jan 1 - July 31, Rising
    month = Time.now.month
    age_value = Time.now.year - year
    if (month >= 8)
      "#{I18n.t('team.name.under')}#{age_value + 1}"
    else
      "#{I18n.t('team.name.under')}#{age_value} (Rising #{I18n.t('team.name.under')}#{age_value + 1})"
    end
  end

  def two_digit_year
    year.to_s.last(2) unless year.nil?
  end

  def to_s
#    "'#{two_digit_year} #{gender} #{name} #{team_level.name}" unless team_level.nil?
    "#{age} #{gender} #{name} #{team_level.name} '#{two_digit_year}" unless team_level.nil?
  end

  def admin_permalink
    admin_team_path(self)
  end

  def crop_team_image
    image.recreate_versions! if crop_x.present?
  end

  def as_json(options = {})
    { :id => id, :name => to_s }
  end

  def to_param
    "#{id} #{to_s}".parameterize if id
  end

  def self.to_team_name_with_coach(id)
    if not id.nil?
      team = Team.find(id)
      team.to_team_name_with_coach unless team.nil?
    end
  end

  def to_team_name_with_coach
    "#{to_s} coached by #{coach}"
  end

  def teamsnap_roster_url
    "http://go.teamsnap.com/#{teamsnap_team_id}/roster/list"
  end

  def teamsnap_schedule_url
    "http://go.teamsnap.com/#{teamsnap_team_id}/schedule"
  end

  def teamsnap_json

    return {} if teamsnap_team_id == TEAMSNAP_NO_TEAM_ID

    mutex = Mutex.new

    #endpoints = [record, schedule, roster]
    endpoints = [schedule, roster]
    threads = []
    json = {}

    for endpoint in endpoints
      threads << Thread.new(endpoint) { |myEndpoint|
        results = myEndpoint
        mutex.synchronize do
          json = json.merge(results)
        end
      }
    end

    threads.each { |aThread|  aThread.join }

    json
  end

  def record
    record = {}
    teamsnap("https://api.teamsnap.com/v2/teams/#{teamsnap_team_id}") do |http_code, json|
      if (http_code == '200')
        record = {record: json['team']['formatted_record']}
      else
        log_teamsnap_error 'record', json
      end
    end

    record
  end

  def schedule
    schedule = []
    teamsnap("https://api.teamsnap.com/v2/teams/#{teamsnap_team_id}/as_roster/#{TEAMSNAP_ROSTER_ID}/events/upcoming") do |http_code, json|
      if http_code != '200'
        schedule << json
      else
        json.each do |game|
          event = game['event']
          name = "#{event['shortlabel'].nil? || event['shortlabel'].blank? ? event['type'] : event['shortlabel']}"
          if (event['type'] == 'Game')
            name += " #{event['home_or_away'].nil? || event['home_or_away'] == 1 ? 'vs.' : 'at'} #{event['opponent']['opponent_name']}"
          end
          date_start = DateTime.parse(event['event_date_start'])
          date_end = DateTime.parse(event['event_date_end'])

          schedule << {
              name: name,
              date: date_start.strftime("%a, %b %d"),
              start: date_start.strftime("%I:%M %p"),
              end: (date_start == date_end ? nil : date_end.strftime("%I:%M %p")),
              location: event['location']['location_name']
          }
        end
      end
    end

    {schedule: schedule}
  end

  def roster
    players = []
    managers = []
    teamsnap("https://api.teamsnap.com/v2/teams/#{teamsnap_team_id}/as_roster/#{TEAMSNAP_ROSTER_ID}/rosters") do |http_code, json|
      if http_code == '200'
        json.each do |player|
          players << {first: player['roster']['first'], last: player['roster']['last']}  unless player['roster']['non_player'] == true
          if player['roster']['is_owner'] == true
            managers << {first: player['roster']['first'], last: player['roster']['last']}
          end
        end
      else
        log_teamsnap_error 'roster', json
        managers << {first: 'Coming', last: 'soon ...'}
      end
    end

    {players: players, managers: managers}
  end

protected
  def self.genders
    [I18n.t('team.gender.boys'), I18n.t('team.gender.girls')]
  end

  ACADEMY_YEAR = 9
end

def log_teamsnap_error(method, json)
  logger.error "Unable to locate #{method} for team #{teamsnap_team_id}: #{json}"
end

def teamsnap(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)
  request['Content-Type'] = 'application/json'
  request['X-Teamsnap-Token'] = ENV['TEAMSNAP_TOKEN']

  response = http.request(request)
  json = JSON.parse(response.body)

  yield(response.code, json)
end

