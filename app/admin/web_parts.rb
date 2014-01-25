ActiveAdmin.register WebPart do

  actions :index, :show, :new, :create, :update, :edit
  permit_params :html, :name, :translations_attributes

  form :partial => "form"

  controller do
    cache_sweeper :web_part_sweeper, :only => [:create, :update, :destroy]

    def show
      @web_part = WebPart.find(params[:id])
      show! #it seems to need this
    end
    def new
      @web_part = WebPart.new
      ADDITIONAL_LOCALES.each do |lang|
        @web_part.translations.find_or_initialize_by_locale(lang[0])
      end
      new!
    end

    def edit
      @web_part = WebPart.find(params[:id])
      ADDITIONAL_LOCALES.each do |lang|
        @web_part.translations.find_or_initialize_by_locale(lang[0])
      end
      edit!
    end
  end

end
