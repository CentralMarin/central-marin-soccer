# encoding: utf-8

ActiveAdmin.register TeamLevel do

  menu :label => 'Level', :parent => 'Teams'
  permit_params :name, :translations_attributes => [:name, :locale, :id]

  show do |level|
    attributes_table do
      row :name do
        level.name
      end
      row 'Nombre' do
        translation = level.translations.find_by_locale('es')
        translation.name if translation
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.translated_inputs "Translated fields", switch_locale: false do |t|
      t.input :name
    end
    f.actions
  end

end
