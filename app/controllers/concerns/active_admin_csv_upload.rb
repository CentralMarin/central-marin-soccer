module ActiveAdminCsvUpload

  # Shared member actions. Using "send" due to "_action" and "_item" are a private methods
  def self.included(base)

    base.send(:collection_action, :upload_csv, :title => 'Contacts Upload', :method => :get) do
      render 'admin/csv/contacts_upload_csv'
    end

    base.send(:action_item, :only => :index) do
      link_to 'Upload CSV', :action => 'upload_csv'
    end

    base.send(:collection_action, :import_csv, :method => :post) do
      process_csv params[:dump][:file]

      flash[:notice] = 'CSV imported successfully!'
      redirect_to :action => :index
    end

  end
end
