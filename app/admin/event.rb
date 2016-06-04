ActiveAdmin.register Event do

  include ActiveAdminTranslate
  include ActiveAdminCsv

  permit_params :category, :title, :description, :image_url, :cost, :translations_attributes => [:title, :description, :locale, :id], :event_details_attributes => [:id, :start, :length, :location_id, :_destroy, :boys_age_groups => [], :girls_age_groups => []]

  action_item :tryout, only: :index do
    link_to "Tryout Sheets", action: 'tryout_sheets'
  end

  collection_action :tryout_sheets, title: 'Generate Tryout Spreadsheets', method: :get do

    # Hookup to the Google Drive
    session = TryoutsController.authorize
    @ws = session.spreadsheet_by_title TryoutRegistration.sheet_name

    render xlsx: 'tryouts', formats: 'xlsx'
  end

  index :download_links => [:csv] do
    column :category
    column :title
    column :cost do |event|
      number_to_currency event.cost
    end
    column :details do |event|
      table_for event.event_details do
        column :boys_age_groups do |event_detail|
          event_detail.boys_age_groups.to_s
        end
        column :girls_age_groups do |event_detail|
          event_detail.girls_age_groups.to_s
        end
        column :start
        column :length
        column :location do |event_detail|
          event_detail.location_name
        end
        column :registrations do |event_detail|
          link_to event_detail.player_portals.length, download_registrations_admin_event_path(event_detail.id)
        end
      end
    end

    actions
  end

  member_action :download_registrations do

    @detail = EventDetail.find(params[:id])
    event_name = "#{@detail.event.title} - #{@detail.start.strftime('%m-%d-%Y')}"

    render xlsx: 'event_registrations', filename: event_name, formats: 'xlsx'
  end


  show do |event|
    attributes_table do
      row :category
      row :title do |event|
        show_tanslated(self, event, :title)
      end
      row :description do |event|
        show_tanslated(self, event, :description)
      end
      row :cost
    end
    panel "Event Details" do
      table_for event.event_details do
        column :boys_age_groups do |event_detail|
          event_detail.boys_age_groups.to_s
        end
        column :girls_age_groups do |event_detail|
          event_detail.girls_age_groups.to_s
        end
        column :start
        column :length
        column :location do |event_detail|
          event_detail.location_name
        end
        column :registrations do |event_detail|
          event_detail.player_portals.length
        end
      end
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|

    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs do
      f.input :category, as: :select, collection: Event.categories.keys
      f.input :cost
      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title
        t.input :description, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.has_many :event_details, heading: 'Details', allow_destroy: true do |event_detail|
        event_detail.input :boys_age_groups, collection: EventDetail.values_for_boys_age_groups.map { |w| [w.to_s.humanize.capitalize, w] }, multiple: true, as: :bitmask_attributes
        event_detail.input :girls_age_groups, collection: EventDetail.values_for_girls_age_groups.map { |w| [w.to_s.humanize.capitalize, w] }, multiple: true, as: :bitmask_attributes
        event_detail.input :start, :as => :string, :input_html => {:class => "hasDatetimePicker"}, label: 'Start'
        event_detail.input :length, :as => :select, :collection => [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180], :label => "Duration (minutes)"
        event_detail.input :location_id, as: :select, :collection => Location.all.order(name: :asc)
      end

      f.actions
    end
  end

  controller do

    include ActiveAdminCsvController

    def preserve_data?
      true
    end

    def process_csv_row(row, event)

      if row[0].present? # Is this a new event or adding to existing details
        # determine if this event already exists
        event = Event.joins(:translations)
                    .find_by(category: Event::categories[row[0].to_sym], event_translations: {title: row[2], locale: 'en'})
        if event.nil?
          event = Event.create!(category: row[0], title: row[2], description: row[3], cost: row[1])
          event.translations.create!(locale: :es,
                                     title: (row[4].present? ? row[4] : nil),
                                     description: (row[5].present? ? row[5] : nil))
        end
      end

      # Do we have event details to process?
      if row[6].present? || row[7].present? || row[8].present? || row[9].present? || row[10].present?

        # update length, and location
        length = row[9]
        location = (row[10].present? ? Location.find_by_name(row[10]) : nil)

        start = (row[8].present? ? DateTime.strptime(row[8], '%m/%d/%Y %H:%M') : nil)
        event_detail = EventDetail.find_by(event_id: event.id, start: start, length: length, location: location)
        if event_detail.nil?
          event_detail = EventDetail.new(event_id: event.id,
                              start: start,
                              length: length,
                              location: location
          )
        end

        # update the groups
        event_detail.boys_age_groups = (row[6].present? ? row[6].gsub(' ', '').split(',') : nil)
        event_detail.girls_age_groups = (row[7].present? ? row[7].gsub(' ', '').split(',') : nil)

        event_detail.save!
      end

      event
    end

    def generate_csv(csv, events)
      csv << ['Category', 'Cost', 'Title', 'Description', 'Título', 'Descripción', 'Boys Age Groups', 'Girls Age Groups', 'Start', 'Length', 'Location']

      events.each do |event|
        row = []
        row << event.category
        row << event.cost
        row << event.title
        row << event.description

        spanish = event.translations.find_by(locale: :es)
        row << (spanish ? spanish.title : '')
        row << (spanish ? spanish.description : '')

        event.event_details.each_with_index do |event_detail, index|
          row = ['', '', '', '', '', ''] unless index == 0
          row << event_detail.boys_age_groups.to_s
          row << event_detail.girls_age_groups.to_s
          row << (event_detail.start.nil? ? '' : I18n.l(event_detail.start))
          row << event_detail.length
          row << (event_detail.location.nil? ? '' : event_detail.location.name)

          csv << row
        end
        csv << row if event.event_details.length == 0
      end
    end

    def translation_fields
      [:title, :description]
    end

    def index
      index! do |format|
        format.csv {
          download_csv(Event.all)
        }
      end
    end
  end

end
