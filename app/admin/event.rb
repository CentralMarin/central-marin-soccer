ActiveAdmin.register Event do

  actions :index, :show, :update, :edit
  config.filters = false
  # permit_params :heading, :body, :tout, :status, :translations_attributes => [:heading, :body, :tout, :locale, :id], :event_details_attributes => [:id, :formatted_start, :duration, :location_id, :_destroy, :groups => []]
  permit_params :heading, :body, :tout, :status, :translations_attributes => [:heading, :body, :tout, :locale, :id], :event_groups_attributes => [:id, :_destroy, :event_details_attributes => [:id, :formatted_start, :duration, :location_id, :_destroy], :groups => []]

  index :download_links => false do
    column :type
    column :heading
    column :status do |event|

      case event.status
        when "hide"
          status_tag "Hide Event", :warn, class: 'important'
        when "show"
          status_tag "Show Event", :ok
        when "show_and_tout"
          status_tag "Show Event and Tout on Home Page", :ok
      end

    end

    actions
  end

  show do |event|
    attributes_table do
      row :type
      row :heading
      row (:body) { |event| event.body.html_safe }
      row (:tout)  { |event| event.tout.html_safe }
      row :status
      row :created_at
      row :updated_at

    end
    panel "Event Group Details" do
      table_for event.event_groups do
        column('Age Groups') { |event_group| "Boys: #{event_group.boys_age_range}<br>Girls: #{event_group.girls_age_range}".html_safe }
        column('Details') do |event_group|
          table_for event_group.event_details do
            column 'Start', :formatted_start
            column :duration
            column :location
          end
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
      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :heading
        t.input :body, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
        t.input :tout, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.input :status, label: 'Status', collection: Event.statuses.keys, as: :select

      f.has_many :event_groups, heading: 'Groups', allow_destroy: true do |event_group|
        event_group.input :groups, :label => 'Age Groups', collection: EventGroup.values_for_groups.each.map{|c| [c.to_s.gsub!('_', ' '), c]}, multiple: true, as: :bitmask_attributes

        event_group.has_many :event_details, heading: 'Details', allow_destroy: true do |event_detail|
          event_detail.input :formatted_start, :as => :string, :input_html => {:class => "hasDatetimePicker"}, label: 'Start'
          event_detail.input :duration, :as => :select, :collection => [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180], :label => "Duration (minutes)", :selected => 120
          event_detail.input :location
        end
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
        event.heading = key.humanize.titleize
        event.body = "TODO: Fill out"
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

    event =  Event.find_by_id(params[:event_id])
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

    event_id = params[:event][:id].to_i

    EventGroup.transaction do
      EventGroup.delete_all(:event_id => event_id)

      event = Event.find_by_id(event_id)

      # read the csv
      csv_data = params[:event][:file]
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
        event_detail.location = Location.find_by_name(row[3])

        event_group.event_details << event_detail

        event_group.save!
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
