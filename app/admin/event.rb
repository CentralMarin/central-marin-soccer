ActiveAdmin.register Event do

  actions :index, :show, :update, :edit
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

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
