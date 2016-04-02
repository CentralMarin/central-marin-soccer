ActiveAdmin.register Contact do

  include ActiveAdminCsv
  include ActiveAdminTranslate

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

  index :download_links => [:csv] do
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
        show_tanslated(self, contact, :club_position)
      end
      row :description do
        show_tanslated(self, contact, :description)
      end
      row :name
      row :image do
        image_tag image_path(contact.image_url)
      end
      row :email
      row :bio do
        show_tanslated(self, contact, :bio)
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

  controller do
    include ActiveAdminCsvController

    def process_csv_row(row, contact)
      contact = Contact.create!(name: row[0], email: row[1], bio: row[2], club_position: row[3], description: row[4],
                      category: row[8], row_order: row[9])

      contact.translations.create!(locale: :es,
                                   bio: (row[5].present? ? row[5] : nil),
                                   club_position: (row[6].present? ? row[6] : nil),
                                   description: (row[7].present? ? row[7] : nil))

      image_path = Rails.root.join('public' + row[10])
      contact.image = image_path.open if row[10].present? && image_path.exist?
      contact.save!

      contact
    end

    def generate_csv(csv, contacts)
      csv << ['Name', 'Email', 'Bio', 'Club Position', 'Description', 'Biografía', 'Posición', 'Descripción', 'Category', 'Order']

      contacts.each do |contact|
        row = []
        row << contact.name
        row << contact.email
        row << contact.bio
        row << contact.club_position
        row << contact.description

        spanish = contact.translations.find_by(locale: :es)
        row << (spanish ? spanish.bio : '')
        row << (spanish ? spanish.club_position : '')
        row << (spanish ? spanish.description : '')

        row << contact.category
        row << contact.row_order
        row << contact.image

        csv << row
      end
    end

    def translation_fields
      [:bio, :club_position, :description]
    end

    def index
      index! do |format|
        format.csv {
          download_csv(Contact.all)
        }
      end
    end
  end
end


