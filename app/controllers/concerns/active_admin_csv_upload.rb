module ActiveAdminCsvUpload

  # Shared member actions. Using "send" due to "_action" and "_item" are a private methods
  def self.included(base)

    base.send(:collection_action, :upload_csv, :method => :get) do
      @page_title = "Upload #{resource_class.to_s} CSV"
      @model = resource_class.to_s
      render 'admin/csv/upload_csv'
    end

    base.send(:action_item, :only => :index) do
      link_to 'Upload CSV', :action => 'upload_csv'
    end

    base.send(:collection_action, :import_csv, :method => :post) do
      resource_class.transaction do

        # remove all the existing records
        resource_class.destroy_all

        csv_data = params[:csv][:file]
        csv_file = csv_data.read
        CSV.parse(csv_file, {:headers => true}) do |row|
          process_csv_row(resource_class.new, row)
        end

      end

      flash[:notice] = 'CSV imported successfully!'
      redirect_to :action => :index
    end

  end

  def import_csv_file(csv_data)
    transaction do
      # remove all the existing records
      destroy_all

      # read the csv
      csv_file = csv_data.read
      CSV.parse(csv_file, {:headers => true}) do |row|
        yield new(), row
      end

    end
  end
end
