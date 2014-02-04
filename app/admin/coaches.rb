ActiveAdmin.register Coach, {:sort_order => "name_asc"} do

  permit_params :name, :email, :bio, :image, :crop_x, :crop_y, :crop_w, :crop_h,:translations_attributes => [:bio, :locale, :id]

  index do
    column :name
    column :image do |coach|
      image_tag image_path(coach.image_url)
    end
    column :bio do |coach|
      html_overview(coach.bio)
    end
    column :team do |coach|
      coach.teams.join("<br/>").html_safe
    end
    default_actions

  end

  show do |coach|
    attributes_table do
      row :name
      row :email
      row :image do
        # TODO: Put a default image up if we don't have one. See about using the a 404 handler to accomplish this
        image_tag image_path(coach.image_url)
      end
      row :bio do
        I18n.available_locales.each do |locale|
          h3 I18n.t( "coach.bio", locale: locale)
          div do
            translated_coach = coach.translations.where(locale: locale).first
            if (translated_coach.nil? || translated_coach.bio.nil?)
              h4 b "Missing"
            else
              h4 translated_coach.bio.html_safe
            end
          end
        end
      end
      row :team do
        coach.teams.join("<br/>").html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  #form :partial => "form"

  form do |f|
    f.inputs do
      f.input :name
      f.input :email

      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :bio, :as => :ckeditor, :input_html => {:ckeditor => {:toolbar => 'Easy', :language => "#{t.object.locale}", :scayt_sLang => "#{SPELLCHECK_LANGUAGES[t.object.locale.to_sym]}"}}
      end

      f.input :crop_x, :as => :hidden
      f.input :crop_y, :as => :hidden
      f.input :crop_w, :as => :hidden
      f.input :crop_h, :as => :hidden
      f.input :image, :as => :file, :hint => f.template.image_tag(f.object.image.url(), :id => "cropbox")
    end
    f.actions     <<

    "<script>
      $(document).ready(soccer.image_crop.init({
        modelName: 'coach',
        width: #{CoachImageUploader::ImageSize::WIDTH},
        height: #{CoachImageUploader::ImageSize::HEIGHT}
      }));
    </script>".html_safe
  end

  #TODO: Attempt to rename the image if the coaches name is changed

end
