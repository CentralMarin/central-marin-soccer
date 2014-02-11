ActiveAdmin.register Tryout do

  permit_params :gender_id, :age, :start, :duration, :field_id, :is_makeup

  index do
    column :gender
    column :age
    column "Date" do |tryout|
      tryout.date_to_s
    end
    column :field
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
      row "Display" do
        tryout.to_s
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :gender_id, :as => :select, :collection => Gender.all, :label_method => :name, :value_method => :id, :include_blank => false
      f.input :age, :as => :select, :collection => [9,10,11,12,13,14,15,16,17,18,19]
      f.input :start, :as => :string, :input_html => {:class => "hasDatetimePicker"}
      f.input :duration, :as => :select, :collection => [1,2, 3], :label => "Duration (hours)", :selected => 2
      f.input :field
      f.input :is_makeup
    end
    f.actions
  end
  
end
