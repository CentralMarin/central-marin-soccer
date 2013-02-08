ActiveAdmin.register WebPart do
  menu :if => proc{ can?(:manage, WebPart) }

  actions :index, :show, :new, :create, :update, :edit

  form :partial => "form"

  controller do
    def show
      @coach = Coach.find(params[:id])
      @versions = @coach.versions
      @coach = @coach.versions[params[:version].to_i].reify if params[:version]
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
