# encoding: utf-8

ActiveAdmin.register TeamLevel do

  include ActiveAdminTranslate

  menu :label => 'Level', :parent => 'Teams'
  permit_params :name, :translations_attributes => [:name, :locale, :id]

  show do |level|
    attributes_table do
      row :name do
        show_tanslated(self, level, :name)
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


  controller do
    def translation_fields
      [:name]
    end
  end

end
