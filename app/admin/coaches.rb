ActiveAdmin.register Coach, {:sort_order => "name_asc"} do

  menu :if => proc{ can?(:manage, Coach) }

  index do
    column :name
    column :image do |coach|
      image_tag image_path(coach.image_url)
    end
    column :bio do |coach|
      html_overview(coach.bio)
    end
    column :team do |coach|
      coach.teams.join("<br/>").html_safe
    end
    default_actions

  end

  show do |coach|
    attributes_table do
      row :name
      row :email
      row :image do
        # TODO: Put a default image up if we don't have one. See about using the a 404 handler to accomplish this
        image_tag image_path(coach.image_url)
      end
      row :bio do
        I18n.available_locales.each do |locale|
          h3 I18n.t( "coach.bio", locale: locale)
          div do
            translated_coach = coach.translations.where(locale: locale).first
            if (translated_coach.nil? || translated_coach.bio.nil?)
              h4 b "Missing"
            else
              h4 translated_coach.bio.html_safe
            end
          end
        end
      end
      row :team do
        coach.teams.join("<br/>").html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form :partial => "form"

  #TODO: Attempt to rename the image if the coaches name is changed

  controller do
    cache_sweeper :coach_sweeper, :only => [:create, :update, :destroy]

    def show
      @coach = Coach.find(params[:id])
      @versions = @coach.versions
      @coach = @coach.versions[params[:version].to_i].reify if params[:version]
      show! #it seems to need this
    end
    def new
      @coach = Coach.new
      ADDITIONAL_LOCALES.each do |lang|
        @coach.translations.find_or_initialize_by_locale(lang[0])
      end
      new!
    end

    def edit
      @coach = Coach.find(params[:id])
      ADDITIONAL_LOCALES.each do |lang|
        @coach.translations.find_or_initialize_by_locale(lang[0])
      end
      edit!
    end
  end

  sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @coach = Coach.find(params[:id])
    @versions = @coach.versions
    render "layouts/history"
  end

  # Buttons
  # show this button only at :show action
  action_item :only => :show do
    link_to "History", :action => "history"
  end

  # show this button only at :history action
  action_item :only => :history do
    link_to "Back", :action => "show"
  end
end
