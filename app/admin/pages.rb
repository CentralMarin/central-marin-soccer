ActiveAdmin.register Page do

  menu :label => 'CMS'
  config.filters = false

  actions :index

  index pagination_total: false, :download_links => false do
    column :name
    column "English" do |page|
      link_to "edit", page.url if session[:edit_pages]
    end
    column "Spanish" do |page|
      link_to "editar", "#{request.protocol}es.#{request.host_with_port}#{page.url}" if session[:edit_pages]
    end
    column "Last Updated", :updated_at

  end

  action_item :only => :index do
    if session[:edit_pages] == true
      link_to "Cancel Edit", :action => "cancel_edit_pages"
    else
      link_to "Edit Mode", :action => "edit_pages"
    end
  end

  collection_action :edit_pages, :method => :get do
    session[:edit_pages] = true
    redirect_to collection_path
  end

  collection_action :cancel_edit_pages, :method => :get do
    session[:edit_pages] = false
    redirect_to collection_path
  end
end
