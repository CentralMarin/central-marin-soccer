ActiveAdmin.register Event do

  actions :index, :show, :update, :edit
  config.filters = false
  permit_params :heading, :body, :tout, :status, :translations_attributes => [:heading, :body, :tout, :locale, :id], :event_details_attributes => [:id, :formatted_start, :duration, :location_id, :_destroy, :groups => []]

  show do |event|
    attributes_table do
      row :type
      row :heading
      row :body
      row :tout
      row :status
    end
    panel "Event Item Details" do
      table_for event.event_details do
        column :formatted_start
        column :duration
        column :location
        column :groups
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
      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :heading
        t.input :body, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
        t.input :tout, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.input :status, label: 'Status', collection: Event.statuses.keys, as: :select

      f.has_many :event_details, heading: 'Event Details', allow_destroy: true do |event_detail|
        event_detail.input :formatted_start, :as => :string, :input_html => {:class => "hasDatetimePicker"}, label: 'Start'
        event_detail.input :duration, :as => :select, :collection => [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180], :label => "Duration (minutes)", :selected => 120
        event_detail.input :location
        event_detail.input :groups, :label => 'Age Groups', collection: EventDetail.values_for_groups.each.map{|c| [c.to_s.gsub!('_', ' '), c]}, multiple: true, as: :bitmask_attributes
      end

      f.actions
    end
  end


  # Make sure all of the default events exist so the admin can administer them
  collection_action :create_events, method: :get do

    # Create all the events in our enum if they don't already exist
    Event.types.each do |key, value|
      puts "#{value}"
      unless Event.where("type = ?", value).exists?
        event = Event.new
        event.type = key.to_sym
        event.status= :hide
        event.save!
      end
    end

    flash[:notice] = 'Events created'
    redirect_to collection_path
  end

  action_item :only => :index do
    link_to 'Seed Events', :action => 'create_events'
  end

  collection_action :download_csv, method: :get do

    file = CSV.generate do |csv|
      csv << ['start', 'duration', 'location', 'groups']

      event_details = EventDetail.where(:event_id => params[:event_id])
      event_details.each do |event_detail|
        row = []
        row << event_detail.formatted_start
        row << event_detail.duration
        row << event_detail.location.name
        row << event_detail.groups.join(', ')
        csv << row
      end
    end

    send_data file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;filename=event-details#{params[:id]}.csv"
  end

  collection_action :upload_csv, method: :get do
    @event_id = params[:event_id]
    render 'admin/csv/event_details_upload_csv'
  end

  collection_action :import_csv, :method => :post do

    event_id = params[:event][:id].to_i

    EventDetail.transaction do
      # remove all the existing records for the specified event
      EventDetail.delete_all(:event_id => event_id)

      event = Event.find_by_id(event_id)

      # read the csv
      csv_data = params[:event][:file]
      csv_file = csv_data.read
      CSV.parse(csv_file, {:headers => true}) do |row|
        event_detail = EventDetail.new()
        event_detail.formatted_start = row[0]
        event_detail.duration = row[1]
        event_detail.location = Location.find_by_name(row[2])

        groups = row[3].gsub(' ', '').split(',')

        event_detail.groups = groups
        event_detail.event = event

        event_detail.save!
      end

    end

    flash[:notice] = 'CSV imported successfully!'
    redirect_to admin_event_path(params[:event][:id])
  end

  action_item :only => :show do
    link_to 'Download Event Item CSV', :action => 'download_csv', :event_id => event.id
  end

  action_item :only => :show do
    link_to 'Upload Event Item CSV', :action => 'upload_csv', :event_id => event.id
  end

end
