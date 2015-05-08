ActiveAdmin.register Contact do

  include ActiveAdminCsvUpload

  permit_params :name, :email, :bio, :club_position, :description, :category, :image, :crop_x, :crop_y, :crop_w, :crop_h, :translations_attributes => [:bio, :club_position, :description, :locale, :id]

  config.filters = false
  config.sort_order = 'row_order_asc'
  config.paginate = false

  ranked(:row_order)

  scope :all, default: true
  scope :voting_board_member
  scope :nonvoting_board_member
  scope :other_assistance
  scope :coaching

  index do
    ranked_handle_column(:row_order)
    column :id
    column :category do |contact|
      contact.category.humanize.titleize
    end
    column :club_position
    column :name
    column :email
    column :image
    actions
  end

  show do |contact|
    attributes_table do
      row :category
      row :club_position do
        show_translated_model_field(contact, :club_position)
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
        t.input :club_position
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

  csv do
    column :name
    column :email
    column :bio
    column :club_position
    column :description
    column :category
    column :row_order
  end

end


def process_csv_row(contact, row)
    contact.name = row[0]
    contact.email = row[1]
    contact.bio = row[2]
    contact.club_position = row[3]
    contact.description = row[4]
    contact.category = row[5]
    contact.row_order = row[6]

    contact.save!
end