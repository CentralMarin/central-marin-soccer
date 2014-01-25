ActiveAdmin.register Field, {:sort_order => "name_asc"} do

  permit_params :name, :club, :rain_line, :address, :status

  index do
    column :name
    column :club
    column :rain_line
    column(:map_url) {|field| link_to 'directions', field.map_url}
    column(:status) { |field| field.status_name }
    default_actions

  end

  show do |field|
    attributes_table do
      row :name
      row :club
      row :rain_line
      row :address
      row 'Latitude' do
        field.lat
      end
      row 'Longitude' do
        field.lng
      end
      row :map do
        map_url = field.map_url + "&output=embed"
        iframe width: "640",
               height: "640",
               frameborder: "10",
               scrolling: "no",
               marginheight: "0",
               marginwidth: "0",
               src: map_url.html_safe
      end
      row :status do
        field.status_name
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Edit Field" do
      f.input :name
      f.input :club
      f.input :rain_line
      f.input :address
      f.input :status, :collection => Field.statuses.each_with_index.map {|c, index| [c, index]}, :as => :select, :label => "Status"
    end
    f.actions
  end

  controller do
    cache_sweeper :home_sweeper, :only => [:update_fields_status]
    cache_sweeper :field_sweeper, :only => [:create, :update, :destroy, :update_fields_status]

    def show
        @field = Field.find(params[:id])
        show! #it seems to need this
    end
  end

  collection_action :fields_status, :title => "Field Status", :method => :get do
    @fields = Field.all #Field.find_all_by_club('San Rafael')

    render "admin/fields/_show_statuses"
  end

  collection_action :update_fields_status, :method => :get do
    fields = params[:fields]

    if (fields.kind_of? String)
      fields = [fields]
    end

    fields.each do |field_param|
      id = field_param.to_i
      field = Field.find(id)
      field.status = params[:status]
      field.save
    end

    head :ok
  end

  action_item :only => :index do
    link_to "Update fields", :action => "fields_status"
  end
end
