ActiveAdmin.register Room do
  permit_params :name, :address
  config.filters = false

  index do
    column :name
    column :address
  end

  show do |room|
    attributes_table do
      row :name
      row :address
    end
  end

  form do |f|

    if f.object.errors.size >= 1
      f.inputs "Errors" do
        f.object.errors.full_messages.join('|')
      end
    end

    f.inputs do
      f.input :name
      f.input :address
    end

    f.actions
  end

end