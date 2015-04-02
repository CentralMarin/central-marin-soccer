def translated_contact(field)
  I18n.available_locales.each do |locale|
    translated_contact = contact.translations.where(locale: locale).first
    div do
      if (translated_contact.nil? || translated_contact.send(field).blank?)
        b 'Translation Missing - considering using google translate to get the point across'
      else
        translated_contact.send(field).html_safe
      end
    end
  end
end

ActiveAdmin.register Contact do

  permit_params :name, :email, :bio, :position, :description, :category, :image, :crop_x, :crop_y, :crop_w, :crop_h, :translations_attributes => [:bio, :position, :description, :locale, :id]

  config.filters = false

  show do |contact|
    attributes_table do
      row :category
      row :position do
        translated_contact(:position)
      end
      row :description do
        translated_contact(:description)
      end
      row :name
      row :image do
        image_tag image_path(contact.image_url)
      end
      row :email
      row :bio do
        translated_contact(:bio)
      end
      row :created_at
      row :updated_at
    end
  end

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

      f.inputs do
        f.input :crop_x, :as => :hidden
        f.input :crop_y, :as => :hidden
        f.input :crop_w, :as => :hidden
        f.input :crop_h, :as => :hidden
        f.input :image, :as => :file, :hint => f.object.image.present? \
         ? f.image_tag(f.object.image.url(), :id => "cropbox")
                      : f.image_tag("no_image.png", :id => "cropbox")
      end
    end

    f.actions <<
      "<script>
        $(document).ready(soccer.image_crop.init({
          modelName: 'contact',
          width: #{Contact::IMAGE_WIDTH},
          height: #{Contact::IMAGE_HEIGHT}
        }));
       </script>".html_safe
  end

end
