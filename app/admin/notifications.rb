ActiveAdmin.register Notification do
  form :html => { :enctype => "multipart/form-data" } do |f|

    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs do
      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :subject
        t.input :body, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.actions
    end
  end

  controller do

  end
end