ActiveAdmin.register Tryout do

  permit_params :gender_id, :age, :tryout_start, :start, :duration, :field_id, :is_makeup

  menu :label => 'Tryouts', :parent => 'Tryouts'

  index do
    column :gender
    column :age
    column "Date" do |tryout|
      tryout.date_to_s
    end
    column :field
    column :is_makeup
    actions
  end

  show do |tryout|
    attributes_table do
      row :gender
      row :age
      row "Date" do
        tryout.date_to_s
      end
      row :field
      row :location
      row "Display" do
        tryout.to_s
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :gender_id, :as => :select, :collection => Gender.all, :label_method => :name, :value_method => :id, :include_blank => false
      f.input :age, :as => :select, :collection => [9,10,11,12,13,14,15,16,17,18,19]
      f.input :tryout_start, :as => :string, :input_html => {:class => "hasDatetimePicker"}
      f.input :duration, :as => :select, :collection => [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180], :label => "Duration (minutes)", :selected => 120
      f.input :field
      f.input :location
      f.input :tryout_type
      f.input :is_makeup
    end
    f.actions <<
        "<script>
      function field_changed() {
        if ($('#tryout_field_id option:selected').text()) {
          $('#tryout_location_input').hide();
        } else {
          $('#tryout_location').val('');
          $('#tryout_location_input').show();
        }
      }

      $('#tryout_field_id').change(field_changed);

      field_changed();

     </script>".html_safe
  end

  csv do
    column :gender
    column :age
    column :tryout_start
    column :duration
    column :field
    column :is_makeup
  end

  collection_action :upload_csv, :title => 'Tryouts Uploads', :method => :get do
    render 'admin/csv/tryouts_upload_csv'
  end

  collection_action :import_csv, :method => :post do
    Tryout.transaction do
      # remove all the existing records
      Tryout.destroy_all

      # read the csv
      csv_data = params[:dump][:file]
      csv_file = csv_data.read
      CSV.parse(csv_file, {:headers => true}) do |row|
        tryout = Tryout.new()
        tryout.gender_id = Gender.id(row[0])
        tryout.age = row[1]
        tryout.tryout_start = row[2]
        tryout.duration = row[3]
        if not row[4].blank?
          tryout.field = Field.where("lower(name) = ?", row[4].downcase).first
        end
        tryout.is_makeup = row[5]
        tryout.save!

      end

    end

    redirect_to :action => :index, :notice => 'CSV imported successfully!'
  end

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end
end
