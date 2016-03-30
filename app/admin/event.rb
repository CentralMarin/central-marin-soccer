def generate_csv(events)
  file = CSV.generate do |csv|
    # Determine which event has the most details associated with it so we can generate the appropriate headings?
    csv << ['Category', 'Title', 'Description', 'Cost', 'Boys Age Groups', 'Girls Age Groups', 'Start', 'Length', 'Location']


    events.each do |event|
      row = []
      row << event.category
      row << event.title
      row << event.description
      row << event.cost

      event.event_details.each do |event_detail|
        row << event_detail.boys_age_groups.join(', ')
        row << event_detail.girls_age_groups.join(', ')
        row << event_detail.start
        row << event_detail.length
        row << event_detail.location.name
      end
      csv << row
    end
  end

  send_data file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;filename=events.csv"
end

ActiveAdmin.register Event do

  include ActiveAdminTranslate

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
      event.event_details.each do |event_detail|
        div event_detail.to_s
      end
      nil
    end

    actions
  end

  show do |event|
    attributes_table do
      row :category
      row :title
      row :description
      row :cost
    end
    panel "Event Details" do
      table_for event.event_details do
        column :boys_age_groups do |event_detail|
          event_detail.boys_age_groups.join(', ')
        end
        column :girls_age_groups do |event_detail|
          event_detail.girls_age_groups.join(', ')
        end
        column :start
        column :length
        column :location do |event_detail|
          event_detail.location.name
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

=begin

  collection_action :download_csv, method: :get do

    event =  Event.find_by(id: params[:event_id])
    file = CSV.generate do |csv|
      csv << ['groups', 'start', 'duration', 'location']

      event.event_groups.each do |event_group|
        groups = event_group.groups
        event_group.event_details.each do |event_detail|
            row = []
            row << groups.join(', ')
            row << event_detail.formatted_start
            row << event_detail.duration
            row << event_detail.location.name
            csv << row
        end
      end
    end

    send_data file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;filename=#{event.heading}.csv"
  end

  collection_action :upload_csv, method: :get do
    @event_id = params[:event_id]
    render 'admin/csv/event_details_upload_csv'
  end

  collection_action :import_csv, :method => :post do

    event_id = params[:events][:id].to_i

    EventGroup.transaction do
      EventGroup.delete_all(:event_id => event_id)

      event = Event.find_by_id(event_id)

      # read the csv
      csv_data = params[:events][:file]
      csv_file = csv_data.read
      previous_groups = ''
      event_group = nil
      CSV.parse(csv_file, {:headers => true}) do |row|
        groups = row[0].gsub(' ', '').split(',')
        if groups != previous_groups
          event_group = EventGroup.new(groups: groups, event_id: event_id)
          previous_groups = groups
        end

        event_detail = EventDetail.new()
        event_detail.formatted_start = row[1]
        event_detail.duration = row[2]
        event_detail.location = Location.find_by(name: row[3])

        event_group.event_details << event_detail

        event_group.save!
      end
    end

    flash[:notice] = 'CSV imported successfully!'
    redirect_to admin_event_path(params[:events][:id])
  end

  action_item :download_csv, :only => :show do
    link_to 'Download Event Item CSV', :action => 'download_csv', :event_id => event.id
  end

  action_item :upload_csv, :only => :show do
    link_to 'Upload Event Item CSV', :action => 'upload_csv', :event_id => event.id
  end

  controller do
    def translation_fields
      [:heading, :body, :tout]
    end
  end
=end
  controller do
    def index
      index! do |format|
        format.csv {
          generate_csv(@events)
        }
      end
    end
  end

end
