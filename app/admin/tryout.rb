ActiveAdmin.register Tryout do

  permit_params :gender_id, :age, :date, :time_start, :time_end, :field_id, :is_makeup

  index do
    column :gender
    column :age
    column "Date" do |tryout|
      tryout.date_to_s
    end
    column "Time" do |tryout|
      tryout.time_to_s
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
      row "Time" do
        tryout.time_to_s
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
      f.input :age
      f.input :date
      f.input :time_start
      f.input :time_end
      f.input :field
      f.input :is_makeup
    end
    f.actions
  end
  
end
