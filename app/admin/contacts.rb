ActiveAdmin.register Contact do

  permit_params :name, :email, :bio, :position, :description, :category, :image, :crop_x, :crop_y, :crop_w, :crop_h, :translations_attributes => [:bio, :position, :description, :locale, :id]

  config.filters = false
  config.sort_order = ['category_asc', 'position_asc']

  index do
    column :category do |contact|
      contact.category.humanize.titleize
    end
    column :position
    column :name
    column :email
    column :image
    actions
  end

  show do |contact|
    attributes_table do
      row :category
      row :position do
        show_translated_model_field(contact, :position)
      end
      row :description do
        show_translated_model_field(contact, :description)
      end
      row :name
      row :image do
        image_tag image_path(contact.image_url)
      end
      row :email
      row :bio do
        show_translated_model_field(contact, :bio)
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
