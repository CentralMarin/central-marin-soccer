ActiveAdmin.register Contact do

  permit_params :name, :email, :bio, :position, :description, :category, :translations_attributes => [:bio, :position, :description, :locale, :id]

  config.filters = false

  form :html => { :enctype => "multipart/form-data" } do |f|

    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs 'Position' do

      f.input :category, label: 'Category', collection: Contact.categories.keys, as: :select, include_blank: false

      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :position
        t.input :description, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.inputs 'Contact Information' do
        f.input :name
        f.input :email

        f.translated_inputs "Translated fields", switch_locale: false do |t|
          t.input :bio, :as => :ckeditor, :input_html => {:ckeditor => {:language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
        end
      end

    end

    f.actions
  end

end
