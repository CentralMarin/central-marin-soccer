ActiveAdmin.register Page do

  menu :label => 'CMS'
  config.filters = false
  config.sort_order = "name_asc"

  actions :index

  index pagination_total: false, :download_links => false do
    column :name do |page|
      if session[:edit_pages]
        link_to page.name, page.url
      else
        page.name
      end
    end
    column "Parts" do |page|
      html = page.web_parts.map {|part| part.name}.join ('<br>')
      html.html_safe
    end
    column "Last Updated" do |page|
      last_updated = page.web_parts.order("updated_at DESC").first.updated_at
      last_updated.in_time_zone('Pacific Time (US & Canada)').strftime("%m/%d/%Y %l:%M %Z")
    end

  end

  action_item :edit_pages, :only => :index do
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

  controller do
    def scoped_collection
      super.includes :web_parts # prevents N+1 queries to your database
    end
  end
end
