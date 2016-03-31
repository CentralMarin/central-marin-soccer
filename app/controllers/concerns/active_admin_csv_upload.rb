module ActiveAdminCsvUpload

  # Shared member actions. Using "send" due to "_action" and "_item" are a private methods
  def self.included(base)

    base.send(:collection_action, :import, :method => :get) do
      @page_title = "Import #{resource_class.to_s} CSV"
      @model = resource_class.to_s
      render 'admin/csv/upload_csv'
    end

    base.send(:action_item, :only => :index) do
      link_to "Import #{resource_class.to_s.pluralize}", :action => 'import'
    end

    base.send(:collection_action, :import_csv, :method => :post) do
      resource_class.transaction do

        # remove all the existing records
        resource_class.destroy_all

        csv_data = params[:csv][:file]
        csv_file = csv_data.read.force_encoding('UTF-8')
        result = nil
        CSV.parse(csv_file, :headers => true) do |row|
          result = process_csv_row(row, result)
        end

      end

      flash[:notice] = 'CSV imported successfully!'
      redirect_to :action => :index
    end

  end
end
