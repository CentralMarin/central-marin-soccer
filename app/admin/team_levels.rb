# encoding: utf-8

ActiveAdmin.register TeamLevel do

  menu :label => 'Level', :parent => 'Teams'
  permit_params :name, :translations_attributes => [:name, :locale, :id]

  show do |level|
    attributes_table do
      row :name do
        show_translated_model_field(level, :name)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.translated_inputs "Translated fields", switch_locale: false do |t|
        t.input :name
      end
    end
    f.actions
  end

end
