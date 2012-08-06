ActiveAdmin.register Field, {:sort_order => "name_asc"} do

  menu :if => proc{ can?(:manage, Field) }

  controller.authorize_resource

  index do
    column :name
    column :club
    column :rain_line
    column(:map_url) {|field| link_to 'directions', field.map_url}
    column :state_id, :sortable => :'state_id' do |field|
      Field::STATES[field.state_id]
    end
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
      row :state_id
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
      f.input :state_id, :collection => Field::STATES.each_with_index.map {|c, index| [c.to_s, index]}, :as => :select, :label => "State"
    end
    f.buttons
  end

  controller do
    def show
        @field = Field.find(params[:id])
        @versions = @field.versions
        @field = @field.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end
  end
    sidebar :versions, :partial => "layouts/version", :only => :show

  member_action :history do
    @field = Field.find(params[:id])
    @versions = @field.versions
    render "layouts/history"
  end

  collection_action :fields_status, :title => "test", :method => :get do
    @fields = Field.find_all_by_club('San Rafael')

    render "admin/fields/_show_states"
  end

  collection_action :update_fields_status, :method => :get do
    fields = params[:fields]
    state_id = params[:state_id].to_i

    if (fields.kind_of? String)
      fields = [fields]
    end

    fields.each do |field_param|
      id = field_param.to_i
      field = Field.find(id)
      field.state_id = state_id.to_i
      field.save
    end

    head :ok
  end

  # Buttons
  # show this button only at :show action
  action_item :only => :show do
    link_to "History", :action => "history"
  end

  action_item :only => :index do
    link_to "Update fields", :action => "fields_status"
  end

  # show this button only at :history action
  action_item :only => :history do
    link_to "Back", :action => "show"
  end
end
