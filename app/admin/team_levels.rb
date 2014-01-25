# encoding: utf-8

ActiveAdmin.register TeamLevel do

  menu :label => 'Level', :parent => 'Teams'
  permit_params :name, :translations_attributes

  show do |level|
    attributes_table do
      row :name do
        level.name
      end
      #row 'Nombre' do
      #  translation = level.translations.find_by_locale('es')
      #  translation.name if translation
      #end
      row :created_at
      row :updated_at
    end
  end

  form :partial => 'form'

  controller do
    def show
        @level = TeamLevel.find(params[:id])
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

end
