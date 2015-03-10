ActiveAdmin.register Event do

  actions :index, :show, :update, :edit
  config.filters = false
  permit_params :heading, :body, :tout, :status, :translations_attributes => [:heading, :body, :tout, :locale, :id]

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

      f.input :status, label: 'Status', collection: Event.statuses.keys, as: :radio
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
end
