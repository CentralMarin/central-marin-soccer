module ActiveAdminTranslate

  # Shared member actions. Using "send" due to "_action" and "_item" are a private methods
  def self.included(base)

    base.send(:collection_action, :translate, :method => :get) do
      id = params[:id]
      model =  resource_class.find_by(id: id)
      fields = translation_fields

      translator = BingTranslator.new(Rails.application.secrets.bing_client_id, Rails.application.secrets.bing_client_secret)

      english_translations = model.translations.find_by(locale: :en)
      spanish_translation = model.translations.find_by(locale: :es)
      if spanish_translation.nil?
        spanish_translation = model.translations.new
        spanish_translation.locale = :es
      end

      fields.each do |field|
        content = english_translations.send(field)
        spanish = translator.translate(content, from: 'en', to: 'es')

        spanish_translation.send("#{field}=", spanish)
      end

      status = spanish_translation.save

      flash[:notice] = 'Content Translated!'
      redirect_to action: :show, id: id
    end

    base.send(:action_item, :only => :show) do
      link_to 'Translate to Spanish', :action => 'translate', id: params[:id]
    end

  end

end
