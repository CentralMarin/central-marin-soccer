# encoding: utf-8

ActiveAdmin.register TeamLevel do

  menu :if => proc{ can?(:manage, TeamLevel) }, :label => 'Level', :parent => 'Teams'

  show do |level|
    attributes_table do
      row :name do
        level.name
      end
      row 'Nombre' do
        translation = level.translations.find_by_locale('es')
        translation.name if translation
      end
      row :created_at
      row :updated_at
    end
  end

  form :partial => 'form'

  controller do
    def show
        @level = TeamLevel.find(params[:id])
        @versions = @level.versions
        @level = @level.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end

    def new
      @team_level = TeamLevel.new
      ADDITIONAL_LOCALES.each do |lang|
        @team_level.translations.find_or_initialize_by_locale(lang[0]) unless lang[0] == :en
      end
      new!
    end

    def edit
      @team_level = TeamLevel.find(params[:id])
      ADDITIONAL_LOCALES.each do |lang|
        @team_level.translations.find_or_initialize_by_locale(lang[0]) unless lang[0] == :en
      end
      edit!
    end
  end

  sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @level = TeamLevel.find(params[:id])
    @versions = @level.versions
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
