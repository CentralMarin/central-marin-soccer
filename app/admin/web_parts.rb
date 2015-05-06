ActiveAdmin.register WebPart do

  actions :index, :show, :new, :create, :update, :edit
  permit_params :html, :name, :translations_attributes => [:html, :locale, :id]

show do |webpart|
  attributes_table do
    row :part do
      show_translated_model_field(webpart, :html)
    end
  end
end

form do |f|
    f.inputs do
      f.input :name

      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :html, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end
    end
    f.actions
  end
end
